/*
    Lliurex UI toolkit

    Copyright (C) 2024  Enrique Medina Gremaldos <quique@necos.es>

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

import "3dstuff.js" as S3d
import "scenes.js" as Scenes

import net.lliurex.ui.noise 1.0 as Noise

import QtQuick 2.6

Canvas
{
    id: root
    anchors.fill: parent
    antialiasing:false; smooth:false

    property var isWallpaper: true
    property var rats: true
    property var totem: false
    property var baseColor: "#2980b9"
    property var seed : 0
    property var ambient: (isWallpaper) ? 0.2 : 0.4

    // 3d wallpaper properties
    property var bbox: []
    property var cbox: []

    property var draw: null
    property var angle: 0

    property var zoom: 16
    property var ratio: 1

    property var fireflies: []
    property var characters: []
    property var outline: []

    property var scene: Scenes.scenes[0]


    property var images : {

        1: "/usr/share/qml-module-lliurex-ui/media/a01.png",
        2: "/usr/share/qml-module-lliurex-ui/media/a03.png",
        3: "/usr/share/qml-module-lliurex-ui/media/a04.png",
        4: "/usr/share/qml-module-lliurex-ui/media/a05.png",

        5: "/usr/share/qml-module-lliurex-ui/media/c01.png",
        6: "/usr/share/qml-module-lliurex-ui/media/c03.png",
        7: "/usr/share/qml-module-lliurex-ui/media/c04.png",
        8: "/usr/share/qml-module-lliurex-ui/media/c05.png",

        9: "/usr/share/qml-module-lliurex-ui/media/v01.png",
        10: "/usr/share/qml-module-lliurex-ui/media/v03.png",
        11: "/usr/share/qml-module-lliurex-ui/media/v04.png",
        12: "/usr/share/qml-module-lliurex-ui/media/v05.png",

        13: "/usr/share/qml-module-lliurex-ui/media/totem.png",
        14: "/usr/share/qml-module-lliurex-ui/media/a02.png",
        15: "/usr/share/qml-module-lliurex-ui/media/c02.png",
        16: "/usr/share/qml-module-lliurex-ui/media/v02.png",

        17: "/usr/share/qml-module-lliurex-ui/media/f00.png",
        18: "/usr/share/qml-module-lliurex-ui/media/f01.png",
    }

    function rand_int(start,end) {
        var range = (end + 1 ) - start;
        var value =  Math.floor(Math.random() * range);

        return start + value;
    }

    /* Drawing functions */
    function insert_draw_r(type,node,d,z)
    {
        var nz = node[0];

        if (nz>z) {
            if (node[1]==null) {
                node[1] = [z,null,null,type,d];
            }
            else {
                insert_draw_r(type,node[1],d,z);
            }
        }
        else {
            if (node[2]==null) {
                node[2] = [z,null,null,type,d];
            }
            else {
                insert_draw_r(type,node[2],d,z);
            }
        }
    }

    function insert_draw(type,d,z)
    {
        if (draw == null) {
            draw = [z,null,null,type,d];
        }
        else {
            insert_draw_r(type,draw,d,z);
        }
    }

    function draw_triangle(a,b,c,color)
    {
        var z = (a[2] + b[2] + c[2])/3.0;

        insert_draw(0,[a,b,c,color],z);
    }

    function draw_sprite(sprite,position,sw,sh)
    {
        insert_draw(1,[sprite,position,sw,sh],position[2]);
    }

    function draw_line(a,b,color,size)
    {
        var z = (a[2] + b[2])/2.0;
        insert_draw(2,[a,b,color,size],z);
    }

    function flush_r(node,ctx)
    {
        if (node == null) {
            return;
        }

        flush_r(node[2],ctx);

        //draw triangle
        if (node[3] == 0) {
            var vertices = node[4];
            ctx.strokeStyle = "#000000";
            ctx.fillStyle = node[4][3];
            ctx.beginPath();
            var a = towin(vertices[0]);
            var b = towin(vertices[1]);
            var c = towin(vertices[2]);

            ctx.moveTo(a[0],a[1]);
            ctx.lineTo(b[0],b[1]);
            ctx.lineTo(c[0],c[1]);
            ctx.lineTo(a[0],a[1]);

            ctx.fill();
            //ctx.stroke();
        }

        //draw sprite
        if (node[3] == 1) {
            var img = node[4][0];
            var pos = node[4][1];
            var sw = node[4][2];
            var sh = node[4][3];
            var win = towin(pos);

            //console.log("drawing image ",img,pos,win);
            var ww = width / (zoom);
            var w = ww*sw;
            var h = ww*sh;
            //console.log(w,h);
            //ctx.drawImage(img,win[0],win[1]-h,w,h);

            // hack
            if (img == images[13]) {
                win[1]+=32;
            }

            ctx.drawImage(img,win[0]-(sw/2),win[1]-sh,sw,sh);

        }

        //draw line
        if (node[3] == 2) {
            var a = towin(node[4][0]);
            var b = towin(node[4][1]);
            var color = node[4][2];
            var size = node[4][3];

            ctx.strokeStyle = color;
            ctx.beginPath();
            ctx.moveTo(a[0],a[1]);
            ctx.lineTo(b[0],b[1]);
            ctx.stroke();
        }

        flush_r(node[1],ctx);
    }

    function flush(ctx)
    {
        flush_r(draw,ctx);

        draw = null;
    }

    function towin(v)
    {
        const left = -zoom ;
        const right = zoom ;
        const top = -zoom * ratio;
        const bottom = zoom * ratio;

        var x = (width/2.0) + (v[0] * (width/(right-left)));
        var y = (height/2.0) + (v[1] * (height/(top-bottom)));

        return [x,y];
    }

    /* Drawing functions */

    Component.onCompleted:
    {
        for (var n=1;n<10;n++) {
            loadImage(images[n]);
        }

        if (isWallpaper && rats) {
            totem = (Math.random() > 0.9);
        }

        bbox = S3d.box(scene);
        cbox = S3d.center(bbox);

        var xwide = bbox[1][0] - bbox[0][0];
        var zwide = bbox[1][2] - bbox[0][2];

        var spread = 5;
        for (var n=0;n<8;n++) {
            var x = cbox[0] + (Math.random() * spread*2) - spread;
            var y = 2; //bbox[1][1] - 0;
            var z = cbox[2] + (Math.random() * spread*2) - spread;
            fireflies.push([2*x,2*y,2*z]);

        }

        var places = [];
        for (var s=0;s<scene.length;s++) {

            var tx = (scene[s][0][0] - cbox[0]) * 2;
            var ty = (scene[s][0][1] - bbox[1][1]) * 2;
            var tz = (scene[s][0][2] - cbox[2]) * 2;

            var color = scene[s][1];

            if (totem) {
                if (color == S3d.KEYCODE_TOTEM) {
                    places.push([tx,ty,tz]);
                }
            }
            else {
                if (color == S3d.KEYCODE_MICE) {
                    places.push([tx,ty,tz]);
                }
            }

        }

        places = places.sort( () => Math.random() - 0.5 );

        if (totem) {
            characters.push([images[13],places[0]]);
            characters.push([images[14],places[1]]);
            characters.push([images[15],places[2]]);
            characters.push([images[16],places[3]]);
        }
        else {
            characters.push([images[rand_int(1,4)],places[0]]);
            characters.push([images[rand_int(5,8)],places[1]]);
            characters.push([images[rand_int(9,12)],places[2]]);
        }
    }

    function computeRatio()
    {
        ratio = height/width;
    }

    onWidthChanged:
    {
        computeRatio();
    }

    onHeightChanged:
    {
        computeRatio();
    }

    onImageLoaded:
    {
        requestPaint();
    }

    onPaint: function()
    {
        var ctx = getContext("2d");

        //ctx.clearRect(0, 0, width, height);
        var background = S3d.color4_from_bytes(0x34,0x49,0x5e,0xff);
        //ctx.fillStyle = "#ff34495e";

        if (isWallpaper) {
            var r0 = width * 0.2;
            var r1 = width * 0.8;
            var cx = width/2;
            var cy = height/2;
            var grd = ctx.createRadialGradient(cx,cy, r0, cx,cy, r1);
            grd.addColorStop(0, S3d.color4_create_hex(S3d.COLOR_BASE));
            grd.addColorStop(1, "#ff000000");
            ctx.fillStyle = grd;
            ctx.fillRect(0,0,width,height);
        }
        else {
            ctx.fillStyle = S3d.color4_create_hex(S3d.COLOR_BASE);
            ctx.fillRect(0,0,width,height);
        }

        var cube = S3d.create_box(1,2);
        var semi = S3d.semicylinder(1,6,2);

        var mrot = S3d.mat4_create_rot_y(Math.PI/4 + angle);
        var mrot2 = S3d.mat4_create_rot_x(-0.7);

        var lights = [];

        if (isWallpaper) {
            for (var f=0;f<fireflies.length;f++) {
                var mv = S3d.mat4_create_translate(fireflies[f][0],fireflies[f][1],fireflies[f][2]);

                mv = S3d.mat4_mult(mv,mrot);
                mv = S3d.mat4_mult(mv,mrot2);

                var pos = S3d.vec4_mult([1.0,0,-1.0,1],mv);
                lights.push([pos,[1,1,1,1],40]);
                var ffsprite = (Math.random() > 0.5 ) ? 17 : 18;
                //draw_sprite(images[ffsprite],pos,0.5,0.5);
                draw_sprite(images[ffsprite],pos,32,32);
            }

            if (rats) {
                for (var c=0;c<characters.length;c++) {
                    var img = characters[c][0];
                    var tx = characters[c][1][0];
                    var ty = characters[c][1][1];
                    var tz = characters[c][1][2];

                    var mv = S3d.mat4_create_translate(tx,ty,tz);

                    mv = S3d.mat4_mult(mv,mrot);
                    mv = S3d.mat4_mult(mv,mrot2);

                    var pos = S3d.vec4_mult([1.0,0.1,-1.0,1],mv);

                    if (img == images[13]) {
                        lights.push([pos,[1,1,1,1],200]);
                    }

                    //draw_sprite(img,pos,1.5,3);
                    draw_sprite(img,pos,128,256);
                }
            }
        }
        else {
            var mv = S3d.mat4_create_translate(cbox[0],8,cbox[2])
            mv = S3d.mat4_mult(mv,mrot);
            mv = S3d.mat4_mult(mv,mrot2);
            var pos = S3d.vec4_mult([0,0,0,1],mv);
            lights.push([pos,[1,1,1,1],120]);
            //draw_sprite(images[9],pos,0.5,0.5);
        }

        for (var l=0;l<outline.length;l++) {
            var a = outline[l][0];
            var b = outline[l][1];

            var mv = S3d.mat4_create_translate(a[0],a[1],a[2]);

            mv = S3d.mat4_mult(mv,mrot);
            mv = S3d.mat4_mult(mv,mrot2);
            var posa = S3d.vec4_mult([0.0,-0.1,0.0,1],mv);

            mv = S3d.mat4_create_translate(b[0],b[1],b[2]);

            mv = S3d.mat4_mult(mv,mrot);
            mv = S3d.mat4_mult(mv,mrot2);
            var posb = S3d.vec4_mult([0.0,-0.1,0.0,1],mv);

            draw_line(posa,posb,outline[l][2],outline[l][3]);
        }

        for (var s=0;s<scene.length;s++) {

            var tx = (scene[s][0][0] - cbox[0]) * 2;
            var ty = (scene[s][0][1] - bbox[1][1]) * 2;
            var tz = (scene[s][0][2] - cbox[2]) * 2;


            var color = scene[s][1];

            var mv = S3d.mat4_create_identity();

            var mesh = cube;

            if (color === S3d.KEYCODE_MICE) {
                continue
            }

            if (color === S3d.KEYCODE_TOTEM ) {
                continue;
            }

            if (color === S3d.KEYCODE_EDGE_N ) {
                mesh = semi;
            }

            if (color === S3d.KEYCODE_EDGE_E ) {
                mesh = semi;
                var m = S3d.mat4_create_rot_y((Math.PI/2) * 1);
                mv = S3d.mat4_mult(mv,m);
            }

            if (color === S3d.KEYCODE_EDGE_S ) {
                mesh = semi;
                var m = S3d.mat4_create_rot_y((Math.PI/2) * 2);
                mv = S3d.mat4_mult(mv,m);
            }

            if (color === S3d.KEYCODE_EDGE_W ) {
                mesh = semi;
                var m = S3d.mat4_create_rot_y((Math.PI/2) * 3);
                mv = S3d.mat4_mult(mv,m);
            }

            var mt = S3d.mat4_create_translate(tx,ty,tz);
            mv = S3d.mat4_mult(mv,mt);
            mv = S3d.mat4_mult(mv,mrot);
            mv = S3d.mat4_mult(mv,mrot2);

            for (var n=0;n<mesh.length;n+=3) {
                var va = S3d.vec4_mult(mesh[n],mv);
                var vb = S3d.vec4_mult(mesh[n+1],mv);
                var vc = S3d.vec4_mult(mesh[n+2],mv);

                var vab = S3d.vec4_sub(vb,va);
                vab = S3d.vec4_normalize(vab);

                var vac = S3d.vec4_sub(vc,va);
                vac = S3d.vec4_normalize(vac);

                var normal = S3d.vec4_cross(vab,vac);

                var base = S3d.color4_create(S3d.COLOR_BASE);

                var ocolor = [0,0,0,1];

                ocolor[0] = base[0] * root.ambient;
                ocolor[1] = base[1] * root.ambient;
                ocolor[2] = base[2] * root.ambient;

                ocolor = S3d.color4_clamp(ocolor);

                for (var l=0;l<lights.length;l++) {
                    var lpos = lights[l][0];
                    var lcolor = lights[l][1];
                    var lenergy = lights[l][2];

                    var val = S3d.vec4_sub(lpos,va);
                    val = S3d.vec4_normalize(val);
                    val[3] = 0;
                    var e = [0,0,0,0];
                    var cosAlpha = S3d.vec4_dot(normal,val);

                    var val = S3d.vec4_sub(va,lpos);
                    var ldist = S3d.vec4_dist(val);

                    var attenuation = lenergy/(1 + (1*ldist) + (1*ldist*ldist));

                    if (cosAlpha>0) {
                        e[0] = base[0] * cosAlpha * attenuation;
                        e[1] = base[1] * cosAlpha * attenuation;
                        e[2] = base[2] * cosAlpha * attenuation;

                        ocolor = S3d.color4_add(ocolor,e);

                    }

                }

                const light = S3d.vec4_normalize([1,0,-1,0]);
                const cam = S3d.vec4_normalize([0,0,-1,0]);

                var cosAlpha = S3d.vec4_dot(normal,cam);

                if (cosAlpha<0) {
                    continue;
                }

                cosAlpha = S3d.vec4_dot(normal,light);

                var fade = (scene[s][0][1]+(cube[n][1]/2))/(bbox[1][1]-1);

                ocolor = S3d.color4_blend(ocolor,background,1-fade);
                ocolor = Qt.rgba(ocolor[0],ocolor[1],ocolor[2],1);
                draw_triangle(va,vb,vc,ocolor);
            }

        }

        flush(ctx);

    }

    Noise.UniformSurface
    {
        anchors.fill: parent
        opacity: 0.025
    }

}
