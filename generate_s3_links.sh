#!/bin/sh

cat <<EOF
<html>
<head>
<title>DeepSecurity gem downloads</title>
</head>
<body>
<ul>
EOF

for path in $( ls pkg/*gem ; ls windows-installer/Output/*exe ); do
    file=$( basename $path )
	echo "<li><a href=\"$file\">$file</a></li>"
done

cat <<EOF
</ul>
</body>
</head>
EOF