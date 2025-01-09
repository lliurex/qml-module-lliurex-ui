/*
    qml-module-lliurex-ui

    Copyright (C) 2025  Enrique Medina Gremaldos <quique@necos.es>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

const KEYCODE_MICE = "#d95763";

const COLOR_BACKGROUND = [0x34,0x49,0x5e,0xff];
const COLOR_BASE = [0x28,0x80,0xb9,0xff];




function color4_from_bytes(r,g,b,a)
{
    var c = [0,0,0,0];

    c[0] = r/255.0;
    c[1] = g/255.0;
    c[2] = b/255.0;
    c[3] = a/255.0;

    return c;
}

function color4_clamp(a)
{
    var c = [0,0,0,0];

    c[0] = a[0];
    c[1] = a[1];
    c[2] = a[2];
    c[3] = a[3];

    if (c[0]>1) {
        c[0]=1;
    }

    if (c[1]>1) {
        c[1]=1;
    }

    if (c[2]>1) {
        c[2]=1;
    }

    if (c[3]>1) {
        c[3]=1;
    }

    return c;
}

function color4_add(a,b)
{
    var c = [0,0,0,0];

    c[0] = a[0] + b[0];
    c[1] = a[1] + b[1];
    c[2] = a[2] + b[2];
    c[3] = a[3] + b[3];

    return color4_clamp(c);
}

function color4_blend(a,b,factor)
{
    var c = [0,0,0,0];

    c[0] = a[0] + ((b[0]-a[0])* factor);
    c[1] = a[1] + ((b[1]-a[1])* factor);
    c[2] = a[2] + ((b[2]-a[2])* factor);
    c[3] = a[3] + ((b[3]-a[3])* factor);

    return c;
}

function mat4_create_identity(angle)
{
    return [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]];
}

function mat4_create_rot_x(angle)
{
    var m = [[1,0,0,0],
        [0,Math.cos(angle),Math.sin(angle),0],
        [0,-Math.sin(angle),Math.cos(angle),0],
        [0,0,0,1]];

    return m;
}

function mat4_create_rot_y(angle)
{
    var m = [[Math.cos(angle),0,-Math.sin(angle),0],
    [0,1,0,0],
    [Math.sin(angle),0,Math.cos(angle),0],
    [0,0,0,1]];

    return m;
}

function mat4_create_translate(x,y,z)
{
    var m = [[1,0,0,0],[0,1,0,0],[0,0,1,0],[x,y,z,1]];

    return m;
}

function mat4_create_scale(x,y,z)
{
    var m = [[x,0,0,0],[0,y,0,0],[0,0,z,0],[0,0,0,1]];

    return m;
}

function mat4_mult(a,b)
{
    var m = mat4_create_identity()

    for (var i=0;i<4;i++) {
        for (var j=0;j<4;j++) {
            m[i][j] = (a[i][0]*b[0][j]) + (a[i][1]*b[1][j]) + (a[i][2]*b[2][j]) + (a[i][3]*b[3][j]);
        }
    }

    return m;
}

        function vec4_mult(v,m)
{
    var r = [0,0,0,0];

    r[0] = (m[0][0] * v[0]) + (m[1][0] * v[1]) + (m[2][0] * v[2]) + (m[3][0] * v[3]);

    r[1] = (m[0][1] * v[0]) + (m[1][1] * v[1]) + (m[2][1] * v[2]) + (m[3][1] * v[3]);

    r[2] = (m[0][2] * v[0]) + (m[1][2] * v[1]) + (m[2][2] * v[2]) + (m[3][2] * v[3]);

    r[3] = (m[0][3] * v[0]) + (m[1][3] * v[1]) + (m[2][3] * v[2]) + (m[3][3] * v[3]);

    return r;
}

function vec4_dist(v)
{
    var d = Math.sqrt((v[0]*v[0]) + (v[1]*v[1]) + (v[2]*v[2])+(v[3]*v[3]));

    return d;
}

function vec4_normalize(v)
{
    var r = [0,0,0,0];
    var dist = vec4_dist(v);

    r[0] = v[0]/dist;
    r[1] = v[1]/dist;
    r[2] = v[2]/dist;
    r[3] = v[3]/dist;

    return r;
}

function vec4_dot(a,b)
{
    var r = (a[0]*b[0]) + (a[1]*b[1]) + (a[2]*b[2]) + (a[3]*b[3]);

    return r;
}

function vec4_cross(a,b)
{
    var c = [0,0,0,0];

    c[0] = (a[1]*b[2]) - (a[2]*b[1]);
    c[1] = (a[2]*b[0]) - (a[0]*b[2]);
    c[2] = (a[0]*b[1]) - (a[1]*b[0]);

    return c;
}

function vec4_sub(a,b)
{
    var v = [a[0]-b[0],a[1]-b[1],a[2]-b[2],a[3]-b[3]];

    return v;
}
