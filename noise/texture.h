// SPDX-FileCopyrightText: 2023 Enrique M.G. <quiqueiii@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

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
