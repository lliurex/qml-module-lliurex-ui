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
    property var baseColor: "#2980b9"
    property var tileWidth: 128
    property var tileHeight: 64

    property var map : []
    property var mapWidth: 0

    Component.onCompleted:
    {

    }

    function computeMap()
    {
        //console.log("recomputing scene...")

        var diagonal = Math.sqrt((width*width) + (height*height));

        var b = tileWidth/2;
        var c = tileHeight/2;

        var tileDiagonal = Math.sqrt((b * b) + (c * c));

        mapWidth = Math.ceil(diagonal/tileDiagonal) + 4;
        map = Array(mapWidth * mapWidth);

        //console.log("Diagonal:",diagonal,",",tileDiagonal);
        //console.log("Dimensions:",mapWidth,"x",mapWidth);

        for (var j=0;j<mapWidth;j++) {
            for (var i=0;i<mapWidth;i++) {
                var r = Math.floor(Math.random() * 4);
                map[i+j*mapWidth] = r;
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


        var lx = mapWidth/2;
        var ly = mapWidth/2;

        for (var j=-1;j<nh+1;j++) {
            var offset = (Math.abs(j)%2) == 0 ? 0 : tw/2;
            for (var i=-1;i<nw+1;i++) {
                var color = baseColor;

                var mi =  Math.ceil(mapWidth/2) + i - Math.floor(j/2);
                var mj = 1 + i + Math.floor(j/2) + (Math.abs(j)%2);
                //console.log(i,",",j,"->",mi,",",mj);

                var blockHeight = map[ mi + mj*mapWidth] * 16;

                if (blockHeight<16) {
                    color = Qt.darker(color,1.05);
                }

                var x = offset + (i * tw) ;
                var y = Math.floor(j * th / 2) ;

                //color = Qt.hsva(blockHeight/64,0.5,0.5,1.0);

                if (isWallpaper) {
                    var dx = lx-mi;
                    var dy = ly-mj;

                    var dist = 0.01 + Math.sqrt((dx*dx)+(dy*dy));
                    var attenuation = 1/(dist*0.5);
                    color = Qt.lighter(color, attenuation);
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


                /*
                if(heightDiff > 0) {

                    var sx = (tw/2) * 0.4;
                    var sy = -(th/2) * 0.4;

                    ctx.fillStyle = Qt.darker(color,1.05);
                    ctx.beginPath();
                    ctx.moveTo(x,y + (th/2) - blockHeight);
                    ctx.lineTo(x + (tw/2),y+th - blockHeight);
                    ctx.lineTo(sx+x + (tw/2),sy+y+th - blockHeight);
                    ctx.lineTo(sx+x,sy+y + (th/2) - blockHeight);

                    ctx.fill();
                }
                */

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
                    if (mi == lx && mj==ly) {
                        console.log("center");
                        for (var n=0;n<32;n++) {
                            var sx = x + (tw/2) + (Math.random() * 32) - (16);
                            var sy = y + (th/2) - (Math.random() * 256) ;
                            ctx.fillStyle = Qt.rgba(1,1,1,0.2);
                            ctx.beginPath();
                            ctx.arc(sx,sy,4,0,360,false);
                            ctx.fill();

                        }
                    }
                }
            }
        }

    }

}
