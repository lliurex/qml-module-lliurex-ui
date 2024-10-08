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

#ifndef QML_LLIUREX_NOISE_PLUGIN
#define QML_LLIUREX_NOISE_PLUGIN

#include "noise.h"
#include "texture.h"

#include <QQmlExtensionPlugin>
#include <QObject>
#include <QQuickItem>
#include <QSGGeometryNode>

class NoiseSurface : public QQuickItem
{
    Q_OBJECT
    
    Q_PROPERTY(float frequency MEMBER m_frequency)
    Q_PROPERTY(int depth MEMBER m_depth)
    
public:
    explicit NoiseSurface(QQuickItem* parent = nullptr);

protected:
    virtual QSGNode* updatePaintNode(QSGNode* oldNode, UpdatePaintNodeData* updatePaintNodeData) override;

private:
    QSGGeometryNode* m_Texture;
    double m_width;
    double m_height;
    
    float m_frequency;
    int m_depth;
};

class UniformSurface : public QQuickItem
{
    Q_OBJECT
    
    
public:
    explicit UniformSurface(QQuickItem* parent = nullptr);

protected:
    virtual QSGNode* updatePaintNode(QSGNode* oldNode, UpdatePaintNodeData* updatePaintNodeData) override;

private:
    QSGGeometryNode* m_Texture;
    double m_width;
    double m_height;
    
};

class TiledSurface : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(int size MEMBER m_size)

public:
    explicit TiledSurface(QQuickItem* parent = nullptr);

protected:
    virtual QSGNode* updatePaintNode(QSGNode* oldNode, UpdatePaintNodeData* updatePaintNodeData) override;

private:
    QSGGeometryNode* m_Texture;
    double m_width;
    double m_height;
    double m_size;

};

class Perlin : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int seed MEMBER m_seed)
    Q_PROPERTY(float frequency MEMBER m_frequency)
    Q_PROPERTY(int depth MEMBER m_depth)

public:
    Perlin();

    Q_INVOKABLE float get(float x,float y);

private:
    int m_seed;
    float m_frequency;
    int m_depth;

};

class NoisePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA (IID "Lliurex.Noise")

public:
    explicit NoisePlugin(QObject *parent = nullptr);
    void registerTypes(const char *uri) override;
};


#endif
