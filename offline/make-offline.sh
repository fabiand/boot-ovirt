
PXELINUX=http://jenkins.ovirt.org/user/fabiand/my-views/view/Node/job/fabiand_boo_build_testing/lastSuccessfulBuild/artifact/pxelinux.cfg



curl -s $PXELINUX | while read LINE;
do

[[ "$LINE" =~ '^label (node|engine)' ]] && label=$(echo $LINE | egrep -o " .*")
[[ "$LINE" =~ "http://" ]] && urls=$(echo $LINE | egrep -o "http://[^ ]*")

[[ -n "$urls" ]] && echo $urls


unset label url
done
