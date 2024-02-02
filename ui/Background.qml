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

    Component.onCompleted:
    {
    }

    function computeMap()
    {
        console.log("recomputing scene...")
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

        var diagonal = Math.sqrt((width*width) + (height*height));
        var tileDiagonal = Math.sqrt((tileWidth * tileWidth) + (tileHeight * tileHeight));

        ctx.fillStyle = baseColor;
        ctx.fillRect(0, 0, width, height);
    }
}

//color: "#2980b9"

