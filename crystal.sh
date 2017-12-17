out=`wla-gb C:/Users/Matt/Documents/git/crystal-ace/crystal.asm 2>&1`
echo "$out"
if [ -n "$out" ]; then
    read
	exit 1
fi
out=`wlalink C:/Users/Matt/Documents/git/crystal-ace/crystal_linkfile C:/Users/Matt/Documents/git/crystal-ace/crystal.gb 2>&1`
echo "$out"
if [ -n "$out" ]; then
    read
	exit 1
fi
