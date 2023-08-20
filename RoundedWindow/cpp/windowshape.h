#ifndef WINDOWSHAPE_H
#define WINDOWSHAPE_H

#include <QObject>
#include <QWindow>

class WindowShape : public QObject
{
    Q_OBJECT
public:
    explicit WindowShape(QObject *parent = nullptr);

    Q_INVOKABLE void applyRadius(QWindow *window, int radius);

};

#endif // WINDOWSHAPE_H
