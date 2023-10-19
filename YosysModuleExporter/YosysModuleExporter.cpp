#include <windows.h>
#include <iostream>
#include <string>
#include <vector>

int main() {
    SECURITY_ATTRIBUTES saAttr{};
    HANDLE hChildStdinRead, hChildStdinWrite, hChildStdoutRead, hChildStdoutWrite;

    // Set up the security attributes for the pipe handles.
    saAttr.nLength = sizeof(SECURITY_ATTRIBUTES);
    saAttr.bInheritHandle = TRUE;
    saAttr.lpSecurityDescriptor = NULL;

    // Create pipes for standard input and output.
    if (CreatePipe(&hChildStdinRead, &hChildStdinWrite, &saAttr, 0) &&
        CreatePipe(&hChildStdoutRead, &hChildStdoutWrite, &saAttr, 0)) {
       // std::cerr << "Error creating pipes: " << GetLastError() << std::endl;
       // return 1;
    

        // Create a process to run Yosys.
        STARTUPINFO si;
        PROCESS_INFORMATION pi;
        ZeroMemory(&si, sizeof(STARTUPINFO));
        si.cb = sizeof(STARTUPINFO);
        si.hStdError = hChildStdoutWrite;
        si.hStdOutput = hChildStdoutWrite;
        si.hStdInput = hChildStdinRead;
        si.dwFlags |= STARTF_USESTDHANDLES;

        // Prompt the user for the batch file location
       // std::wstring batchFileLocation;
       // std::wcout << L"Enter the batch file location (e.g., D:/yosys/oss-cad-suite/start.bat): ";
       // std::wcin >> batchFileLocation;

        //LPWSTR procDirec = const_cast<LPWSTR>(batchFileLocation.c_str());
        LPWSTR procDirec = (LPWSTR)L"D:/yosys/oss-cad-suite/start.bat";
        if (CreateProcess(procDirec, NULL, NULL, NULL, TRUE, 0, NULL, NULL, &si, &pi)) {
            // Prompt the user for a module name
            std::string moduleLocation = "D:/SoftwareFrameWork/RISCVProcessor/ALU.v";
            //std::cout << "Enter the module Location: ";
           // std::cin >> moduleLocation;
            std::string savepath = "D:/SoftwareFrameWork/YosysOutputs/";

            // Extract the module name from the full file location
            size_t lastSlash = moduleLocation.find_last_of("/\\");
            if (lastSlash != std::string::npos) {
                std::string moduleNameWithExtension = moduleLocation.substr(lastSlash + 1);

                // Remove the file extension from the module name
                size_t lastDot = moduleNameWithExtension.find_last_of(".");
                std::string moduleName = moduleNameWithExtension.substr(0, lastDot);

                // Send Yosys commands using the user-provided module name
                std::vector<std::string> commands = {
                    "yosys\n",
                    "read_verilog " + moduleLocation + "\n", // Use the module name
                    "splitnets -ports\n",
                    "read_verilog -lib cmos_cells.v\n",
                    "synth\n",
                    "dfflibmap -liberty cmos_cells.lib\n",
                    "abc -liberty cmos_cells.lib\n",
                    "opt_clean\n",
                    "stat -liberty cmos_cells.lib\n",
                    "write_verilog " + savepath + moduleName + "_synth.v\n",
                    "exit\n",
                    "exit\n"
                };


                for (const std::string& command : commands) {
                    DWORD bytesWritten;
                    if (!WriteFile(hChildStdinWrite, command.c_str(), command.size(), &bytesWritten, NULL)) {
                        // std::cerr << "Error writing to pipe: " << GetLastError() << std::endl;
                        break; // Exit the loop if a write error occurs
                    }
                }

                // Close the write end of the input pipe to signal the end of input.

                
                // Read and process output from Yosys

                char buffer[2]{};
                DWORD bytesRead;
                for (int i = 0; i <= 25600;i++) {
                    if(ReadFile(hChildStdoutRead, buffer, sizeof(buffer) - 1, &bytesRead, NULL));
                         std::cout << buffer;
                //while (ReadFile(hChildStdoutRead, buffer, sizeof(buffer) - 1, &bytesRead, NULL) && bytesRead > 0) {
                 //   buffer[bytesRead] = '\0';
                  //  std::cout << buffer; // Print Yosys output to the console
                    
                }
            }
            // Close handles and wait for the Yosys process to exit
            CloseHandle(hChildStdoutRead);
            CloseHandle(hChildStdinWrite);
            CloseHandle(pi.hProcess);
            CloseHandle(pi.hThread);
    
        }
        else {
           // std::cerr << "Error creating Yosys process: " << GetLastError() << std::endl;
          //  return 1;
        }
        }
    else {

    }


    return 0;
}
