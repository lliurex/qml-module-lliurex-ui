/*
 * Copyright (C) 2024 Lliurex project
 *
 * Author:
 *  Enrique Medina Gremaldos <quique@necos.es>
 *
 * Source:
 *  https://github.com/lliurex/qml-module-lliurex-ui
 *
 * This file is a part of qml-module-lliurex.ui.
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

#include "plugin.h"

#include <QQmlExtensionPlugin>
#include <QObject>
#include <QQmlEngine>
#include <QAbstractItemModel>
#include <QMimeData>
#include <QSGTexture>
#include <QSGRectangleNode>
#include <QSGOpaqueTextureMaterial>
#include <QQuickWindow>
#include <QSGImageNode>

#include <iostream>
#include <chrono>

using namespace std;

NoiseSurface::NoiseSurface(QQuickItem* parent)
{
    m_depth=2;
    m_frequency=0.01f;
    
    setFlag(ItemHasContents);
}

QSGNode* NoiseSurface::updatePaintNode(QSGNode* oldNode, UpdatePaintNodeData* updatePaintNodeData)
{
    QSGImageNode  *node = static_cast<QSGImageNode  *>(oldNode);
    //static int seed = 0;
    
    if (!node) {
        node = window()->createImageNode();
        node->setOwnsTexture(true);
        
        QImage* surface = noise::perlin(width(),height(),m_frequency,m_depth);
        QSGTexture* texture = window()->createTextureFromImage(*surface,QQuickWindow::TextureHasAlphaChannel);
        node->setTexture(texture);
        delete surface;
        
        m_width=width();
        m_height=height();
    }
    else {
        double ew = std::abs(m_width-width());
        double eh = std::abs(m_height-height());
        
        if (ew>0.01 || eh>0.01) {
            m_width=width();
            m_height=height();
            
            auto t0 = std::chrono::steady_clock::now();
            QImage* surface = noise::perlin(width(),height(),m_frequency,m_depth);
            auto t1 = std::chrono::steady_clock::now();
            double us = std::chrono::duration_cast<std::chrono::microseconds>(t1-t0).count();
            //clog<<"time: "<<us<<" us"<<endl;
            
            QSGTexture* texture = window()->createTextureFromImage(*surface,QQuickWindow::TextureHasAlphaChannel);
            node->setTexture(texture);
            delete surface;
        }
        
    }
    node->setRect(boundingRect());
    
    return node;
}

UniformSurface::UniformSurface(QQuickItem* parent)
{
    setFlag(ItemHasContents);
}

QSGNode* UniformSurface::updatePaintNode(QSGNode* oldNode, UpdatePaintNodeData* updatePaintNodeData)
{
    QSGImageNode  *node = static_cast<QSGImageNode  *>(oldNode);
    
    if (!node) {
        node = window()->createImageNode();
        node->setOwnsTexture(true);
        
        QImage* surface = noise::uniform(width(),height());
        QSGTexture* texture = window()->createTextureFromImage(*surface,QQuickWindow::TextureHasAlphaChannel);
        node->setTexture(texture);
        delete surface;
        
        m_width=width();
        m_height=height();
    }
    else {
        double ew = std::abs(m_width-width());
        double eh = std::abs(m_height-height());
        
        if (ew>0.01 || eh>0.01) {
            m_width=width();
            m_height=height();
            
            auto t0 = std::chrono::steady_clock::now();
            QImage* surface = noise::uniform(width(),height());
            auto t1 = std::chrono::steady_clock::now();
            double us = std::chrono::duration_cast<std::chrono::microseconds>(t1-t0).count();
            //clog<<"time: "<<us<<" us"<<endl;
            
            QSGTexture* texture = window()->createTextureFromImage(*surface,QQuickWindow::TextureHasAlphaChannel);
            node->setTexture(texture);
            delete surface;
        }
        
    }
    node->setRect(boundingRect());
    
    return node;
}

TiledSurface::TiledSurface(QQuickItem* parent): m_size(64)
{
    setFlag(ItemHasContents);
}

QSGNode* TiledSurface::updatePaintNode(QSGNode* oldNode, UpdatePaintNodeData* updatePaintNodeData)
{
    QSGImageNode  *node = static_cast<QSGImageNode  *>(oldNode);

    if (!node) {
        node = window()->createImageNode();
        node->setOwnsTexture(true);

        QImage* surface = noise::texture::tiled(width(),height(),m_size);
        QSGTexture* texture = window()->createTextureFromImage(*surface,QQuickWindow::TextureHasAlphaChannel);
        node->setTexture(texture);
        delete surface;

        m_width=width();
        m_height=height();
    }
    else {
        double ew = std::abs(m_width-width());
        double eh = std::abs(m_height-height());

        if (ew>0.01 || eh>0.01) {
            m_width=width();
            m_height=height();

            auto t0 = std::chrono::steady_clock::now();
            QImage* surface = noise::texture::tiled(width(),height(),m_size);
            auto t1 = std::chrono::steady_clock::now();
            double us = std::chrono::duration_cast<std::chrono::microseconds>(t1-t0).count();
            //clog<<"time: "<<us<<" us"<<endl;

            QSGTexture* texture = window()->createTextureFromImage(*surface,QQuickWindow::TextureHasAlphaChannel);
            node->setTexture(texture);
            delete surface;
        }

    }
    node->setRect(boundingRect());

    return node;
}

Perlin::Perlin()
{
    m_seed = 0;
    m_frequency = 1.0f;
    m_depth = 1;
}

float Perlin::get(float x, float y)
{
    return noise::get_perlin(x, y, m_frequency, m_depth, m_seed);
}

NoisePlugin::NoisePlugin(QObject* parent) : QQmlExtensionPlugin(parent)
{
}

void NoisePlugin::registerTypes(const char* uri)
{
    qmlRegisterType<Perlin> (uri, 1, 0, "Perlin");
    qmlRegisterType<NoiseSurface> (uri, 1, 0, "NoiseSurface");
    qmlRegisterType<UniformSurface> (uri, 1, 0, "UniformSurface");
    qmlRegisterType<TiledSurface> (uri, 1, 0, "TiledSurface");
    qmlRegisterAnonymousType<QMimeData>(uri, 1);
    
}
