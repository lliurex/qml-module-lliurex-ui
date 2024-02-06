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
        console.log("recomputing scene...")

        var diagonal = Math.sqrt((width*width) + (height*height));

        var b = tileWidth/2;
        var c = tileHeight/2;

        var tileDiagonal = Math.sqrt((b * b) + (c * c));

        mapWidth = Math.ceil(diagonal/tileDiagonal);
        map = Array(mapWidth * mapWidth);

        console.log("Diagonal:",diagonal,",",tileDiagonal);
        console.log("Dimensions:",mapWidth,"x",mapWidth);

        for (var j=0;j<mapWidth;j++) {
            for (var i=0;i<mapWidth;i++) {
                var r =(j * 0.12);
                map[i+j*mapWidth] = r;
            }
        }

        map[Math.floor(mapWidth/2)] = 1;
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
        var nw = width / tileWidth;
        var nh = height / tileHeight * 2;

        for (var j=0;j<nh;j++) {
            var offset = (Math.abs(j)%2) == 0 ? 0 : tw/2;
            for (var i=0;i<nw;i++) {

                var mi = Math.floor(mapWidth/2) + i - Math.floor(j/2);
                var mj = i + Math.floor(j/2);
                console.log(i,",",j,"->",mi,",",mj);

                var value = map[ mi + mj*mapWidth];

                var r = 0.4;
                var g = 0.1;
                var b = value;

                ctx.fillStyle = Qt.rgba(r,g,b,1.0);

                var x = offset + (i * tw) - (0);
                var y = (j * th / 2) - (0);

                ctx.beginPath();
                ctx.moveTo(x,y + (th/2));
                ctx.lineTo(x + (tw/2),y+th);
                ctx.lineTo(x + tw,y+(th/2));
                ctx.lineTo(x + (tw/2),y);
                ctx.lineTo(x,y+(th/2));
                ctx.fill();
            }
        }

        //ctx.fillStyle = baseColor;
        //ctx.fillRect(0, 0, width, height);
    }
}

//color: "#2980b9"

