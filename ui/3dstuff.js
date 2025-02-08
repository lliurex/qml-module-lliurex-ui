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

const KEYCODE_BLOCK = "#5b6ee1";
const KEYCODE_MICE = "#d95763";
const KEYCODE_TOTEM = "#fbf236";
const KEYCODE_EDGE_S = "#5fcde4";
const KEYCODE_EDGE_E = "#639bff";
const KEYCODE_EDGE_N = "#cbdbfc";
const KEYCODE_EDGE_W = "#ffffff";

const COLOR_BACKGROUND = [0x34,0x49,0x5e,0xff];
const COLOR_BASE = [0x28,0x80,0xb9,0xff];

function color4_create(c)
{
    return [c[0]/255,c[1]/255,c[2]/255,c[3]/255];
}

function color4_create_hex(c)
{
    var h = "#";

    h+=c[3].toString(16);
    h+=c[0].toString(16);
    h+=c[1].toString(16);
    h+=c[2].toString(16);

    return h;
}

function color4_copy(c)
{
    return [c[0],c[1],c[2],c[3]];
}

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

function create_box(w,steps)
{
    var vertices = [];
    var ws = (w*2)/steps;

    //XZ
    for (var i=0;i<steps;i++) {
        for (var j=0;j<steps;j++) {
            var x = -w + (i*ws);
            var x2 = x + ws;
            var y = -w + (j*ws);
            var y2 = y + ws;

            vertices.push([x,-w,y,1]);
            vertices.push([x,-w,y2,1]);
            vertices.push([x2,-w,y2,1]);

            vertices.push([x,-w,y,1]);
            vertices.push([x2,-w,y2,1]);
            vertices.push([x2,-w,y,1]);

            vertices.push([x,w,y,1]);
            vertices.push([x,w,y2,1]);
            vertices.push([x2,w,y2,1]);

            vertices.push([x,w,y,1]);
            vertices.push([x2,w,y2,1]);
            vertices.push([x2,w,y,1]);

        }
    }

    //XY
    for (var i=0;i<steps;i++) {
        for (var j=0;j<steps;j++) {
            var x = -w + (i*ws);
            var x2 = x + ws;
            var y = -w + (j*ws);
            var y2 = y + ws;

            vertices.push([x,y,w,1]);
            vertices.push([x2,y,w,1]);
            vertices.push([x,y2,w,1]);

            vertices.push([x2,y,w,1]);
            vertices.push([x2,y2,w,1]);
            vertices.push([x,y2,w,1]);

            vertices.push([x,y,-w,1]);
            vertices.push([x,y2,-w,1]);
            vertices.push([x2,y2,-w,1]);

            vertices.push([x,y,-w,1]);
            vertices.push([x2,y2,-w,1]);
            vertices.push([x2,y,-w,1]);

        }
    }

    //YZ
    for (var i=0;i<steps;i++) {
        for (var j=0;j<steps;j++) {
            var x = -w + (i*ws);
            var x2 = x + ws;
            var y = -w + (j*ws);
            var y2 = y + ws;

            vertices.push([-w,x,y,1]);
            vertices.push([-w,x2,y,1]);
            vertices.push([-w,x,y2,1]);

            vertices.push([-w,x,y2,1]);
            vertices.push([-w,x2,y,1]);
            vertices.push([-w,x2,y2,1]);

            vertices.push([w,x2,y2,1]);
            vertices.push([w,x,y2,1]);
            vertices.push([w,x,y,1]);

            vertices.push([w,x2,y2,1]);
            vertices.push([w,x,y,1]);
            vertices.push([w,x2,y,1]);

        }
    }

    return vertices;
}

function box(scene)
{
    var minv = [0,0,0];
    var maxv = [0,0,0];

    for (var v=0;v<3;v++) {
        minv[v] = scene[0][0][v];
        maxv[v] = scene[0][0][v];
    }

    for (var n=0;n<scene.length;n++) {
        var vertex = scene[n][0];

        for (var v=0;v<3;v++) {
            if (vertex[v] < minv[v]) {
                minv[v] = vertex[v];
            }

            if (vertex[v] > maxv[v]) {
                maxv[v] = vertex[v];
            }
        }
    }

    return [minv,maxv];
}

function center(bbox)
{
    var x = (bbox[0][0] + bbox[1][0]) / 2.0;
    var y = (bbox[0][1] + bbox[1][1]) / 2.0;
    var z = (bbox[0][2] + bbox[1][2]) / 2.0;
    return [x,y,z];
}

function semicylinder(w,steps)
{
    var triangles = [];
    var rad_step = Math.PI / steps;

    for (var n=0;n<steps;n++) {
        var ax = 0;
        var ay = 0;

        var bx = Math.cos(rad_step * n) * w;
        var by = Math.sin(rad_step * n) * w;
        var cx = Math.cos(rad_step * (n + 1)) * w;
        var cy = Math.sin(rad_step * (n + 1)) * w;

        ay = ay - w;
        by = by - w;
        cy = cy - w;

        // top
        triangles.push([ax,w,ay,1]);
        triangles.push([cx,w,cy,1]);
        triangles.push([bx,w,by,1]);

        // bottom
        triangles.push([ax,-w,ay,1]);
        triangles.push([bx,-w,by,1]);
        triangles.push([cx,-w,cy,1]);

        //front
        triangles.push([bx,w,by,1]);
        triangles.push([cx,w,cy,1]);
        triangles.push([cx,-w,cy,1]);

        triangles.push([cx,-w,cy,1]);
        triangles.push([bx,-w,by,1]);
        triangles.push([bx,w,by,1]);


    }

    return triangles;
}
