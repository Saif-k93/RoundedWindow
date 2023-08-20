#include "screenhandler.h"

ScreenHandler::ScreenHandler(QObject *parent)
    : QObject{parent},
    screen(QGuiApplication::primaryScreen()),
    m_screenWidth(screen->geometry().width()),
    m_screenHeight(screen->geometry().height())
{
    QScreen *subScreen = screen.get();
    m_timer = new QTimer(this);
    m_timer->setInterval(100);
    QObject::connect(subScreen, &QScreen::geometryChanged,this,&ScreenHandler::geometryChanged);
    QObject::connect(m_timer, &QTimer::timeout, this, &ScreenHandler::timeout);

}

QVariant ScreenHandler::getScreenWidth(QVariant senderWidth)
{
    return ((m_screenWidth.toInt() - senderWidth.toInt()));
}

QVariant ScreenHandler::getScreenHeight()
{
    return (m_screenHeight.toInt() - 50);
}

void ScreenHandler::setCursorPos(qint32 x, qint32 y)
{
    m_cursor.setPos(x, y);
}

void ScreenHandler::geometryChanged()
{
    m_screenWidth = screen->geometry().width();
    m_screenHeight = screen->geometry().height();
}

void ScreenHandler::cursorTimerStart()
{
    m_timer->start();
}

void ScreenHandler::cursorTimerStop()
{
    if(m_timer->isActive())
        m_timer->stop();
}

void ScreenHandler::timeout()
{
    this->m_CursorX = m_cursor.pos().x();
    emit mouseXChanged();
    this->m_CursorY = m_cursor.pos().y();
    emit mouseYChanged();
}



