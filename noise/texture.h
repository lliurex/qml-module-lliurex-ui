/*
 * Copyright (C) 2024 Lliurex project
 *
 * Author:
 *  Enrique Medina Gremaldos <quique@necos.es>
 *
 * Source:
 *  https://github.com/lliurex/qml-module-lliurex-ui
 *
 * This file is a part of qml-module-lliurex-ui.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 */

#ifndef QML_LLIUREX_NOISE_TEXTURE
#define QML_LLIUREX_NOISE_TEXTURE

#include <QImage>

namespace noise
{
    namespace texture
    {
        QImage* tiled(int width,int height,int tileSize);
    }
}

#endif
