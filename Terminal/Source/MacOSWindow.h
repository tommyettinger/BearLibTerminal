// Stub

#ifndef BEARLIBTERMINAL_MACOSWINDOW_H
#define BEARLIBTERMINAL_MACOSWINDOW_H

#ifdef __APPLE__

#include <string>
#include <cstdint>
#include "Window.hpp"
#include "BearLibTerminal.h"

#define BLTPostEvent 0x800

namespace BearLibTerminal
{
    class MacOSWindow: public Window
    {
    public:
        MacOSWindow();
        ~MacOSWindow();
        Size GetActualSize();
        bool ValidateIcon(const std::wstring& filename);
        void SetTitle(const std::wstring& title);
        void SetIcon(const std::wstring& filename);
        void SetClientSize(const Size& size);
        void Show();
        void Hide();
        std::future<void> Post(std::function<void()> func);
        void SwapBuffers();
        void SetVSync(bool enabled);
        void SetResizeable(bool resizeable);
        void ToggleFullscreen();
        void SetCursorVisibility(bool visible);
        void Delay(int period);

        struct EventBox;
        void HandleNSWindowEvent(EventBox& box);
    protected:
        void ThreadFunction();
        bool Construct();
        void Destroy();
        bool PumpEvents();
        void Redraw();
    protected:
        struct Private;
        std::unique_ptr<Private> m_private;
        void StartEventMonitor();
        void StopEventMonitor();
    };
}

#endif

#endif // BEARLIBTERMINAL_MACOSWINDOW_H