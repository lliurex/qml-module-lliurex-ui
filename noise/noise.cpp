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

#include "noise.h"

#include <random>

/*
 * Based on code from:
 * https://gist.github.com/nowl/828013
 * 
 * Copyright: John Nowl <esologic@gmail.com>
*/

int SEED = 0;

static uint8_t hash[] = {208,34,231,213,32,248,233,56,161,78,24,140,71,48,140,254,245,255,247,247,40,
                     185,248,251,245,28,124,204,204,76,36,1,107,28,234,163,202,224,245,128,167,204,
                     9,92,217,54,239,174,173,102,193,189,190,121,100,108,167,44,43,77,180,204,8,81,
                     70,223,11,38,24,254,210,210,177,32,81,195,243,125,8,169,112,32,97,53,195,13,
                     203,9,47,104,125,117,114,124,165,203,181,235,193,206,70,180,174,0,167,181,41,
                     164,30,116,127,198,245,146,87,224,149,206,57,4,192,210,65,210,129,240,178,105,
                     228,108,245,148,140,40,35,195,38,58,65,207,215,253,65,85,208,76,62,3,237,55,89,
                     232,50,217,64,244,157,199,121,252,90,17,212,203,149,152,140,187,234,177,73,174,
                     193,100,192,143,97,53,145,135,19,103,13,90,135,151,199,91,239,247,33,39,145,
                     101,120,99,3,186,86,99,41,237,203,111,79,220,135,158,42,30,154,120,67,87,167,
                     135,176,183,191,253,115,184,21,233,58,129,233,142,39,128,211,118,137,139,255,
                     114,20,218,113,154,27,127,246,250,1,8,198,250,209,92,222,173,21,88,102,219};

static int noise2(int x, int y)
{
    uint8_t index = (y + SEED);
    uint8_t tmp = hash[index];
    index = tmp + x;
    return hash[index];
}

static float lin_inter(float x, float y, float s)
{
    return x + s * (y-x);
}

static float smooth_inter(float x, float y, float s)
{
    return lin_inter(x, y, s * s * (3.0f-2.0f*s));
}

static float noise2d(float x, float y)
{
    int x_int = x;
    int y_int = y;
    float x_frac = x - x_int;
    float y_frac = y - y_int;
    int s = noise2(x_int, y_int);
    int t = noise2(x_int+1, y_int);
    int u = noise2(x_int, y_int+1);
    int v = noise2(x_int+1, y_int+1);
    
    float low = smooth_inter(s, t, x_frac);
    float high = smooth_inter(u, v, x_frac);
    
    return smooth_inter(low, high, y_frac);
}

static float perlin_2d(float x, float y, float freq, int depth)
{
    float xa = x*freq;
    float ya = y*freq;
    float amp = 1.0f;
    float fin = 0.0f;
    float div = 0.0f;
    
    for(int i=0; i<depth; i++)
    {
        div += 256.0f * amp;
        fin += noise2d(xa, ya) * amp;
        amp *= 0.5f;
        xa *= 2.0f;
        ya *= 2.0f;
        
    }

    return fin/div;
}

float noise::get_perlin(float x, float y, float freq, int depth,int seed)
{
    SEED = seed;

    return perlin_2d(x, y, freq, depth);
}

QImage* noise::perlin(int width,int height,float freq,int depth,int seed)
{
    //ugly
    SEED = seed;
    
    QImage* img = new QImage(width,height,QImage::Format_RGB32);
    
    for (int j=0;j<height;j++) {
        for (int i=0;i<width;i++) {
            float value = perlin_2d(i,j,freq,depth);
            uint8_t grey = 255.0 * value;
            QColor pixel(grey,grey,grey);
            img->setPixelColor(i,j,pixel);
        }
    }
    
    return img;
}

QImage* noise::uniform(int width,int height,int seed)
{
    std::default_random_engine generator;
    std::uniform_int_distribution<int> distribution(0,255);
    
    QImage* img = new QImage(width,height,QImage::Format_RGB32);
    
    for (int j=0;j<height;j++) {
        for (int i=0;i<width;i++) {
            uint8_t grey = distribution(generator);
            QColor pixel(grey,grey,grey);
            img->setPixelColor(i,j,pixel);
        }
    }
    
    return img;
}
