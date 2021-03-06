#!/bin/sh
# copyright (c) 2011 Gregory Hainaut
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This package is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

INPUT=0
MACRO=""
ENTRY="-noentry"
TEST=/tmp/test.glsl
GL_VERSION=330
NOFRAG=0
NOVERT=0
# VERT="cgc -oglsl -profile glslv -po version=$GL_VERSION"
# FRAG="cgc -oglsl -profile glslf -po version=$GL_VERSION"
# Uniform buffer not supported on glsl ...
#VERT="cgc -oglsl -profile vp40"
#FRAG="cgc -oglsl -profile fp40"
VERT="cgc -oglsl -profile gp5vp"
FRAG="cgc -oglsl -profile gp5fp"

######################################################
# Options
######################################################
help()
{
    cat <<EOF
Help:
    --input <file>         : input glsl file (mandatory)
    --macro <name> <value> : set a macro. Can be repeated
    --entry <name>         : set an entry point. Note: print the ASM output of the program
    --test_gs              : test of gs glsl file
    --nofrag               : disable fragment processing
    --novert               : disable vertex processing
EOF
    exit
}

while [ -n "$1" ]; do
case $1 in
    --help|--h)  help;shift 1;;
    --input|--i) INPUT=$2; shift 2;;
    --macro|--m) MACRO="${MACRO}#define $2 $3\n"; shift 3;;
    --entry|--e) ENTRY="-entry $2";shift 2;;
    --test_gs )  TEST_GS=1; shift 1;;
    --nofrag)    NOFRAG=1; shift 1;;
    --novert)    NOVERT=1; shift 1;;

    --*) echo "ERROR: $1 option does not exists. Use -h for help";exit 1;;
    *)  break;;
esac
done

if [ "$INPUT" = "0" ] ; then
    help
fi

######################################################
# Functions
######################################################
head()
{
    \rm -f $TEST
    touch $TEST
    echo "#version $GL_VERSION" >> $TEST
}

tail()
{
    cat $INPUT >> $TEST
    # Some layout syntax (420) are not supported
    # so I remove them (a bit overkill)
    #sed -i -e 's/layout(.*)//' $TEST
    sed -i -e 's/layout(binding.*)//' $TEST
    sed -i -e 's/layout(location.*)//' $TEST
    sed -i -e 's/, binding.*)/)/' $TEST
}

vertex_test()
{
    head
    echo "#define VERTEX_SHADER 1" >> $TEST
    echo -e $MACRO >> $TEST
    tail

    echo "Vertex check with macro : $MACRO"
    $VERT $ENTRY $TEST
    echo ""
}

fragment_test()
{
    head
    echo "#define FRAGMENT_SHADER 1" >> $TEST
    echo -e "$MACRO" >> $TEST
    echo "Fragment check with macro : "
    echo -e "$MACRO"

    tail
    $FRAG $ENTRY $TEST
    echo ""
}

######################################################
# Main
######################################################

if [ "$TEST_GS" = '1' ] ; then
    echo "not yet implemented"
    # A very big shader example (124 instructions!)
    ./validate_glsl.sh --input $INPUT --novert --entry ps_main --macro PS_TCC 0 --macro PS_TFX 0 --macro PS_IIP 1 --macro PS_ATST 4 --macro PS_FST 1 --macro PS_BLEND 4 --macro PS_COLCLIP 3 --macro PS_SHUFFLE 1 --macro PS_LTF 1 --macro PS_FMT 6 --macro PS_AEM 0 --macro PS_FBMASK 1 --macro PS_FOG 1 --macro PS_WMS 2 --macro PS_WMT 3

    # TODO
    # Maybe it would be nice to make several loop to iterate on various option and to monitor the impact on the instruction number

else
    if [ "$NOVERT" = '0' ] ; then vertex_test; fi
    if [ "$NOFRAG" = '0' ] ; then fragment_test; fi
fi
