####################
#Copyright (c) 2011, iContact Corporation
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#    * Neither the name of the <organization> nor the
#      names of its contributors may be used to endorse or promote products
#      derived from this software without specific prior written permission.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
#DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
####################

# datearray() -- Take date information and place it in an array.
function datearray(A, p1, p2, p3, p4) {
	A["day"]   = p1
	A["month"] = p2
	A["year"]  = p3

	split(p4, Atm, ":")
	A["hour"] = Atm[1]
	A["minute"] = Atm[2]
	A["second"] = Atm[3]

	if (nd == 1) {
		A["repmin"] = "9999"
	} else {
		A["repmin"] = sprintf("%02d%02d", A["hour"], A["minute"])
	}
}

# mkdirs() -- Makes the appropriate path if it does not exist.
function mkdirs(darr, path) {
	wdir = sprintf("mkdir -p %s/%04d/%02d/%02d/archive",path,darr["year"],darr["month"],darr["day"])
	system(wdir)
	close(wdir)
}

# sqldate() -- Turns a date array in to a sql-formatted date.
function sqldate(A) {
	return sprintf("%04d-%02d-%02d %02d:%02d:%02d",A["year"],A["month"],A["day"], A["hour"], A["minute"], A["second"])
}

# strip_equals() -- Strips out everything before an equals sign.
function strip_equals(mystring) {
	gsub(/.*=/,"",mystring)
	return mystring
}

# strip_paren() -- Strips out parentheses.
function strip_paren(mystring) {
	gsub(/\(|\)/,"",mystring)
	return mystring
}

# strip_quotes() -- Strips out single quotes.
function strip_quotes(mystring) {
	gsub(/'/,"",mystring)
	return mystring
}

# replace_underscores() -- Replace underscores.
function replace_underscores(mystring) {
	gsub(/_/," ",mystring)
	return mystring
}

#get_pid() -- Gets the pid number out of a [####] format.
function get_pid(mystring) {
	gsub(/[^0-9]/,"",mystring)
	return mystring
}

# param_array() -- Populate an array from a pipe-delimited string of key/value pairs
function param_array(A, mystring) {
	sub("=|","",mystring)
	split(mystring,tmp_arr,"|")
	for(keyval in tmp_arr) {
		split(tmp_arr[keyval],kv_arr,"=")
		A[kv_arr[1]] = kv_arr[2]
	}
}

# inet_aton() -- convert an IP address to a integer
function inet_aton(myip) {
	split(myip,iparr,".")
	return iparr[1]*16777216+iparr[2]*65536+iparr[3]*256+iparr[4]
}

function newfiles(A, datearr, path) {
	for (fileentry in A) {
		A[fileentry] = sprintf("%s/%04d/%02d/%02d/%s-%04d.csv",path,datearr["year"],datearr["month"],datearr["day"],fileentry,datearr["repmin"])
	}
}

BEGIN {
	Months["Jan"] = "01"
	Months["Feb"] = "02"
	Months["Mar"] = "03"
	Months["Apr"] = "04"
	Months["May"] = "05"
	Months["Jun"] = "06"
	Months["Jul"] = "07"
	Months["Aug"] = "08"
	Months["Sep"] = "09"
	Months["Oct"] = "10"
	Months["Nov"] = "11"
	Months["Dec"] = "12"

	basepath = "/home/jarvis/jarvis/data"
	if (datadir != "") {
		basepath = datadir
	}

	nd = 0
	if (nodate != "") {
		nd = 1
	}
}

