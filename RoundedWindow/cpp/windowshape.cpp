#include "windowshape.h"

WindowShape::WindowShape(QObject *parent)
    : QObject{parent}{}

void WindowShape::applyRadius(QWindow *window, int radius)
{
    QRect r(QPoint(), window->geometry().size());
    QRect rb(0, 0, 2 * radius, 2 * radius);

    QRegion region(rb, QRegion::Ellipse);
    rb.moveRight(r.right());
    region += QRegion(rb, QRegion::Ellipse);
    rb.moveBottom(r.bottom());
    region += QRegion(rb, QRegion::Ellipse);
    rb.moveLeft(r.left());
    region += QRegion(rb, QRegion::Ellipse);
    region += QRegion(r.adjusted(radius, 0, -radius, 0), QRegion::Rectangle);
    region += QRegion(r.adjusted(0, radius, 0, -radius), QRegion::Rectangle);
    window->setMask(region);
}
