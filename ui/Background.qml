/*
    Lliurex UI toolkit

    Copyright (C) 2022  Enrique Medina Gremaldos <quiqueiii@gmail.com>

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

import net.lliurex.ui.noise 1.0

import QtQuick 2.6

Canvas
{
    id: root
    anchors.fill: parent
    antialiasing:false; smooth:false

    property var isWallpaper: false
    property var rats: true
    property var baseColor: "#2980b9"
    property var ambient: 0.1
    property var tileWidth: 128
    property var tileHeight: 64

    property var map : []
    property var items: []
    property var lights: []
    property var mapWidth: 0

    property var images : {
        1 : "/usr/share/qml-module-lliurex-ui/media/01.png",
        2 : "/usr/share/qml-module-lliurex-ui/media/02.png",
        3 : "/usr/share/qml-module-lliurex-ui/media/03.png",
        4 : "/usr/share/qml-module-lliurex-ui/media/04.png",
        5 : "/usr/share/qml-module-lliurex-ui/media/05.png",
        6 : "/usr/share/qml-module-lliurex-ui/media/06.png",
        7 : "/usr/share/qml-module-lliurex-ui/media/07.png"
    }

    Component.onCompleted:
    {
        loadImage(images[1]);
        loadImage(images[2]);
        loadImage(images[3]);
        loadImage(images[4]);
        loadImage(images[5]);
        loadImage(images[6]);
        loadImage(images[7]);
    }

    function computeMap()
    {
        //console.log("recomputing scene...")

        var diagonal = Math.sqrt((width*width) + (height*height));

        var b = Math.floor(tileWidth/2);
        var c = Math.floor(tileHeight/2);

        var tileDiagonal = Math.sqrt((b * b) + (c * c));

        mapWidth = Math.ceil(diagonal/tileDiagonal) + 4;
        map = Array(mapWidth * mapWidth);
        items = Array(mapWidth * mapWidth);

        for (var n=0;n<mapWidth*mapWidth;n++) {
            items[n] = 0;
        }

        for (var j=0;j<mapWidth;j++) {
            for (var i=0;i<mapWidth;i++) {
                var r = Math.floor(Math.random() * 4);
                map[i+j*mapWidth] = r;
            }
        }

        var cx = Math.floor(mapWidth/2);
        var cy = cx;

        items[cx+cy*mapWidth] = 1;

        if (mapWidth>4) {
            var item = 7;

            while (item > 1) {
                var locations = [[0,-3],[0,3],[3,0],[-3,0],[-3,-3],[3,3],[-3,3],[3,-3]];
                var i = Math.floor(Math.random()*(locations.length-1));

                var rx =  cx + locations[i][0];
                var ry =  cy + locations[i][1];

                if (items[rx+ry*mapWidth]!=0) {
                    continue;
                }

                if (Math.random() > 0.5) {
                    items[rx+ry*mapWidth] = item;
                }
                else {
                    items[rx+ry*mapWidth] = item - 1;
                }

                item = item - 2;
            }
        }
        computeLight();

    }

    function getEnergy(x,y,lx,ly,energy)
    {
        var dx = x - lx;
        var dy = y - ly;

        var dist = Math.sqrt((dx*dx)+(dy*dy));
        var v = (energy / (1 + (dist*dist)) );

        if (v<0) {
            v=0;
        }
        return v;
    }

    function computeLight()
    {
        lights = Array(mapWidth * mapWidth);

        for (var n=0;n<mapWidth*mapWidth;n++) {
            lights[n] = 0.0;
        }

        var spotLights = []

        for (var j=0;j<mapWidth;j++) {
            for (var i=0;i<mapWidth;i++) {
                var item = items[i+j*mapWidth];

                if (item == 1) {
                    spotLights.push([i,j,1.2]);
                }

                if (rats && item > 1) {
                    spotLights.push([i,j,0.8]);
                }
            }
        }

        for (var j=0;j<mapWidth;j++) {
            for (var i=0;i<mapWidth;i++) {
                var energy = ambient;

                for (var n=0;n<spotLights.length;n++) {
                    energy=energy + getEnergy(i,j,spotLights[n][0],spotLights[n][1],spotLights[n][2]);
                }

                lights[i+j*mapWidth] = energy;
            }
        }

    }

    onWidthChanged:
    {
        computeMap();
    }

    onHeightChanged:
    {
        computeMap();
    }

    onPaint: function()
    {
        var ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);

        var tw = tileWidth;
        var th = tileHeight;
        var nw = Math.floor(width / tileWidth);
        var nh = Math.floor(height / tileHeight * 2);


        var lx = Math.floor(mapWidth/2);
        var ly = Math.floor(mapWidth/2);

        for (var j=-1;j<nh+1;j++) {
            var offset = (Math.abs(j)%2) == 0 ? 0 : tw/2;
            for (var i=-1;i<nw+1;i++) {
                var color = Qt.lighter(baseColor,1.0);

                var mi =  Math.ceil(mapWidth/2) + i - Math.floor(j/2);
                var mj = 1 + i + Math.floor(j/2) + (Math.abs(j)%2);
                //console.log(i,",",j,"->",mi,",",mj);

                var blockHeight = map[ mi + mj*mapWidth] * 16;
                var item = items[mi + mj*mapWidth];

                if (blockHeight<16) {
                    color = Qt.darker(color,1.05);
                }

                var x = offset + (i * tw) ;
                var y = Math.floor(j * th / 2) ;

                if (isWallpaper) {
                    var energy = lights[mi+mj*mapWidth];
                    color = Qt.rgba(color.r * energy,color.g * energy, color.b*energy,1);
                }

                var leftHeight = map[(mi-1) + mj*mapWidth] * 16;

                var heightDiff = leftHeight - blockHeight;

                ctx.fillStyle = color;
                ctx.beginPath();
                ctx.moveTo(x,y + (th/2) - blockHeight);
                ctx.lineTo(x + (tw/2),y+th - blockHeight);
                ctx.lineTo(x + tw,y+(th/2) - blockHeight);
                ctx.lineTo(x + (tw/2),y - blockHeight);
                ctx.lineTo(x,y+(th/2) - blockHeight);
                ctx.fill();

                ctx.fillStyle = Qt.darker(color,1.1);
                ctx.beginPath();
                ctx.moveTo(x,y + (th/2));
                ctx.lineTo(x + (tw/2),y+th);
                ctx.lineTo(x + (tw/2),y+th - blockHeight);
                ctx.lineTo(x,y+(th/2) - blockHeight);
                ctx.lineTo(x,y+(th/2));
                ctx.fill();

                ctx.fillStyle = Qt.darker(color,1.2);
                ctx.beginPath();
                ctx.moveTo(x+(tw/2),y + th);
                ctx.lineTo(x+tw, y+(th/2));
                ctx.lineTo(x+tw, y+(th/2) - blockHeight);
                ctx.lineTo(x+(tw/2),y + th - blockHeight);
                ctx.lineTo(x+(tw/2),y + th);
                ctx.fill();

                ctx.beginPath();
                ctx.moveTo(x,y + (th/2) - blockHeight);
                ctx.lineTo(x + (tw/2),y+th - blockHeight);
                ctx.lineTo(x + tw,y+(th/2) - blockHeight);
                ctx.lineTo(x + (tw/2),y - blockHeight);
                ctx.lineTo(x,y+(th/2) - blockHeight);
                ctx.strokeStyle = Qt.darker(color,1.5);
                ctx.lineWidth = 0.5;
                ctx.stroke();

                if (isWallpaper) {
                    if (item == 1) {
                        ctx.drawImage(images[1],x,y-192-blockHeight);
                    }

                    if (rats) {
                        if (item == 2) {
                            ctx.drawImage(images[2],x+16,y-192-(th/3)-blockHeight);
                        }

                        if (item == 3) {
                            ctx.drawImage(images[3],x,y-180-(th/3)-blockHeight);
                        }

                        if (item == 4) {
                            ctx.drawImage(images[4],x+12,y-192-(th/3)-blockHeight);
                        }

                        if (item == 5) {
                            ctx.drawImage(images[5],x-4,y-185-(th/3)-blockHeight);
                        }

                        if (item == 6) {
                            ctx.drawImage(images[6],x+16,y-185-(th/3)-blockHeight);
                        }

                        if (item == 7) {
                            ctx.drawImage(images[7],x+20,y-192-(th/3)-blockHeight);
                        }
                    }
                }
            }
        }

    }

}
