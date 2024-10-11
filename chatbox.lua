local function run_python_test()
    os.execute('start /B /min pythonw "C:\\your\\path\\to\\test_script.py"')

    print("Lua attempted to run test_script.py")
end

-- Register the function in the Wireshark Tools menu for easy access
register_menu("Tools/Run Python Test Script", run_python_test, MENU_TOOLS_UNSORTED)
