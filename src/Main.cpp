#include "easm.h"
#include "MipsDisplay.hpp"
#include <memory>

static std::unique_ptr<MipsDisplay> display = std::make_unique<MipsDisplay>();

extern "C" ErrorCode
handleSyscall(uint32_t *regs, void *mem, MemoryMap *mem_map)
{
    unsigned v0 = regs[Register::v0];

    switch (v0)
    {

    // Start Engine Syscall
    case 100:
    {
        if (display->IsRunning())
        {
            std::cerr << "Display engine is already running!" << std::endl;
            return ErrorCode::Ok;
        }

        display->RunEngine();
        return ErrorCode::Ok;
    }

    // Set Pixel Syscall
    case 101:
    {
        uint32_t x = regs[Register::a0];
        uint32_t y = regs[Register::a1];
        uint32_t color = regs[Register::a2];

        display->SetPixel(x, y, color);
        return ErrorCode::Ok;
    }

    // Refresh (flush)
    case 102:
    {
        display->RefreshWindow();
        return ErrorCode::Ok;
    }
    // Clear (with color)
    case 103:
    {
        uint32_t color = regs[Register::a0];

        display->Clear(color);
        return ErrorCode::Ok;
    }

    // Get Key
    case 104:
    {
        regs[Register::v0] = display->GetLastKey();
        return ErrorCode::Ok;
    }

    // Exit
    case 105:
    {
        std::cout << "Exiting..." << std::endl;
        display->StopEngine();
        return ErrorCode::Ok;
    }

    default:
        return ErrorCode::SyscallNotImplemented;
    }
}
