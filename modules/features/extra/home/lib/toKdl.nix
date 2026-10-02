{
  flake.hjemExtraModules.home = {lib, ...}: {
    _module.args.elib.toKdl = let
      inherit
        (builtins)
        isList
        isAttrs
        isBool
        isInt
        isFloat
        isString
        isPath
        isFunction
        toJSON
        filter
        all
        concatMap
        genList
        ;
      inherit
        (lib)
        concatStrings
        concatStringsSep
        mapAttrsToList
        optionalString
        fix
        partition
        ;

      isPlain = v: isAttrs v && !(v ? outPath);
      isNodeList = l: isList l && all isPlain l;

      str = s: toJSON s;
      joinWords = ws: concatStringsSep " " (filter (w: w != "") ws);

      mkVal = version: v:
        if v == null
        then
          (
            if version == 2
            then "#null"
            else "null"
          )
        else if isBool v
        then
          (
            if version == 2
            then
              (
                if v
                then "#true"
                else "#false"
              )
            else
              (
                if v
                then "true"
                else "false"
              )
          )
        else if isInt v || isFloat v
        then toJSON v
        else if isString v
        then str v
        else if isPath v || (isAttrs v && v ? outPath)
        then str "${v}"
        else if isFunction v
        then let
          res = fix v;
        in
          optionalString (res ? type) "(${toString res.type})"
          + (
            if res ? custom
            then res.custom
            else if res ? content
            then mkVal version res.content
            else ""
          )
        else if isAttrs v || isList v
        then str (toJSON v)
        else throw "toKdl: unsupported value type: ${builtins.typeOf v}";

      mkArg = version: a:
        if isPlain a
        then concatStringsSep " " (mapAttrsToList (k: v: "${str k}=${mkVal version v}") a)
        else mkVal version a;

      mkArgs = version: args: let
        p = partition isPlain (
          if isList args
          then args
          else [args]
        );
      in
        joinWords (map (mkArg version) (p.wrong ++ p.right));

      mkChildren = version: ind: lvl: c:
        if isPlain c
        then mapAttrsToList (mkNode version ind lvl) c
        else concatMap (mkChildren version ind lvl) c;

      mkNode = version: ind: lvl: name: val: let
        special = isFunction val;
        res =
          if special
          then fix val
          else val;
        hasContent = !special || res ? content;
        content =
          if special
          then res.content or null
          else res;

        pad = concatStrings (genList (_: ind) lvl);
        nameTok = optionalString (special && res ? type) "(${toString res.type})" + str name;
        props = optionalString (special && res ? props) (mkArgs version res.props);
        head = joinWords [nameTok props];

        hasChildren = hasContent && (isPlain content || (content != [] && isNodeList content));
        children = mkChildren version ind (lvl + 1) content;
      in
        if special && res ? custom
        then
          res.custom {
            indent = ind;
            inherit lvl name;
          }
        else if hasChildren
        then
          if children == []
          then "${pad}${head} {}"
          else "${pad}${head} {\n${concatStringsSep "\n" children}\n${pad}}"
        else pad + joinWords [head (optionalString hasContent (mkArgs version content))];
    in
      value: let
        cfg =
          if isFunction value
          then fix value
          else {content = value;};
        version = cfg.version or 2;
        ind = cfg.indent or "  ";
        lvl = cfg.lvl or 0;
        content = cfg.content;
      in
        if version != 1 && version != 2
        then throw "toKdl: version must be 1 or 2, got ${toString version}"
        else if isPlain content || isNodeList content
        then concatStringsSep "\n" (mkChildren version ind lvl content)
        else throw "toKdl: argument must be an attrset or a list of attrsets (top-level nodes of a KDL file)";
  };
}
