
#!/usr/bin/perl -w
#
# Prevents multiple instances of the argument from running simultaneously.
#
# Copyright 2007-2010 Timothy Kay
# http://timkay.com/solo/
# Modified by Andres Erbsen 2012
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

use Socket;

if ($#ARGV < 1) {die "USAGE: solo LOCKPORT COMMAND...";}
$addr = pack(CnC, 127, $<, 1); # [127,uid[0],uid[1],1]
$^F = 10; # unset close-onexec
socket(LOCKSOCK, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
if ( bind(LOCKSOCK, sockaddr_in($ARGV[0], $addr)) ) {
    exec @ARGV[1..$#ARGV];
} else {
    exit 1;
}
