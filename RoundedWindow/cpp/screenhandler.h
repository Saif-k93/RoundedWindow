#ifndef SCREENHANDLER_H
#define SCREENHANDLER_H

#include <QObject>
#include <QGuiApplication>
#include <QScopedPointer>
#include <QVariant>
#include <QScreen>
#include <QCursor>
#include <QTimer>
#include <QtQml>
#include <QtQuick>

class ScreenHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint32 mouseX MEMBER m_CursorX NOTIFY mouseXChanged FINAL)
    Q_PROPERTY(qint32 mouseY MEMBER m_CursorY NOTIFY mouseYChanged FINAL)
public:
    explicit ScreenHandler(QObject *parent = nullptr);

    Q_INVOKABLE QVariant getScreenWidth( QVariant );
    Q_INVOKABLE QVariant getScreenHeight();
    Q_INVOKABLE void setCursorPos( qint32 , qint32 );

signals:
    void mouseXChanged();
    void mouseYChanged();

public slots:
    void geometryChanged();
    void cursorTimerStart();
    void cursorTimerStop();
    void timeout();

private:
    QScopedPointer<QScreen>screen;
    QVariant m_screenWidth;
    QVariant m_screenHeight;
    QCursor m_cursor;
    qint32 m_CursorX;
    qint32 m_CursorY;
    QTimer* m_timer;

};


#endif // SCREENHANDLER_H
