unit uuencodedecode;

{
    UU Encode and Decode unit.
    Remaked and optimized from Basic code.
    For GNU/Linux 64 bit version.
    Version: 1.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 2025  Artyomov Alexander
    http://self-made-free.ru/
    aralni@mail.ru

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}

{$MODE OBJFPC}
{$H+}
{$SMARTLINK ON}
{$RANGECHECKS ON}

interface

type
 TAoB = array of byte;

function UUDecode(s : string) : string;
function UUEncode(s : string) : string;
function UUDecodeAoB(s : string) : TAoB;
function UUEncodeAoB(b : TAoB) : string;
procedure UUDecodeBuf(const s : string; var b : PByte; h : Int64);
function UUEncodeBuf(b : PByte; h : Int64) : string;

implementation

function UUDecode(s : string) : string;
var
f : Int64 = 1;
begin
result := '';
while f <= Length(s) do begin
    result := result + Chr((Ord(s[f]) - 32) shl 2 + (Ord(s[f+1]) - 32) shr 4);
    result := result + Chr((Ord(s[f+1]) and 15) shl 4 + (Ord(s[f+2]) - 32) shr 2);
    result := result + Chr((Ord(s[f+2]) and 3) shl 6 + Ord(s[f+3]) - 32);
Inc(f, 4);
end;
End;

function UUEncode(s : string) : string;
var
f : Int64 = 1;
begin
result := '';
while f <= Length(s) do begin
    result := result + Chr(Ord(s[f]) shr 2 + 32);
    result := result + Chr((Ord(s[f]) and 3) shl 4 + Ord(s[f+1]) shr 4 + 32);
    result := result + Chr((Ord(s[f+1]) and 15) shl 2 + Ord(s[f+2]) shr 6 + 32);
    result := result + Chr(Ord(s[f+2]) and 63 + 32);
Inc(f, 3);
end;
End;

function UUDecodeAoB(s : string) : TAoB;
var
f : Int64 = 1;
h : Int64;
begin
result := nil;
SetLength(result, 0);
while f <= Length(s) do begin
SetLength(result, Length(result)+3);
h := High(result);
result[h-2] := (Ord(s[f]) - 32) shl 2 + (Ord(s[f+1]) - 32) shr 4;
result[h-1] := (Ord(s[f+1]) and 15) shl 4 + (Ord(s[f+2]) - 32) shr 2;
result[h] := (Ord(s[f+2]) and 3) shl 6 + Ord(s[f+3]) - 32;
Inc(f, 4);
end;
End;

function UUEncodeAoB(b : TAoB) : string;
var
f : Int64 = 0;
begin
result := '';
while f < High(b) do begin
result := result + Chr(b[f] shr 2 + 32);
result := result + Chr((b[f] and 3) shl 4 + b[f+1] shr 4 + 32);
result := result + Chr((b[f+1] and 15) shl 2 + b[f+2] shr 6 + 32);
result := result + Chr(b[f+2] and 63 + 32);
Inc(f, 3);
end;
End;

procedure UUDecodeBuf(const s : string; var b : PByte; h : Int64);
var
f : Int64 = 1;
t : PByte;
begin
h := High(s);
h := h - h shr 2 - 1;
GetMem(b, h);
t := b;
while f <= Length(s) do begin
t[0] := (Ord(s[f]) - 32) shl 2 + (Ord(s[f+1]) - 32) shr 4;
t[1] := (Ord(s[f+1]) and 15) shl 4 + (Ord(s[f+2]) - 32) shr 2;
t[2] := (Ord(s[f+2]) and 3) shl 6 + Ord(s[f+3]) - 32;
Inc(t, 3);
Inc(f, 4);
end;
End;

function UUEncodeBuf(b : PByte; h : Int64) : string;
var
f : Int64 = 0;
begin
result := '';
while f < h do begin
result := result + Chr(b[f] shr 2 + 32);
result := result + Chr((b[f] and 3) shl 4 + b[f+1] shr 4 + 32);
result := result + Chr((b[f+1] and 15) shl 2 + b[f+2] shr 6 + 32);
result := result + Chr(b[f+2] and 63 + 32);
Inc(f, 3);
end;
End;

end.