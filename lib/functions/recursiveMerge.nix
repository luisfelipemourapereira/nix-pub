################################################################################
# if all values to merge are records - merge them recursively
# if all values to merge are arrays - concatenate arrays
# If values can't be merged - the latter value is preferred
################################################################################

let
  recursiveMerge = attrList:
    let f = attrpath:
      zipAttrsWith (n: values:
        if tail values == [ ]
        then head values
        else if all isList values
        then unique (concatLists values)
        else if all isAttrs values
        then f (attrPath ++ [ n ]) values
        else last values
      );
    in f [ ] attrList;
in
recursiveMerge

###############################################################################@
