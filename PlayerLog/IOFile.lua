-- -----------------------------------------------------------------------------
-- I/O Stuff
-- -----------------------------------------------------------------------------
-- Opens a file in append mode
function OpenFile()
    return fs.open("/logger/log.txt", "a")
end

-- Closes a file
function CloseFile(file)
    file.close()                                                              
end

-- Writes to a file
function WriteFile(msg)
    file = OpenFile()
    file.writeLine(msg) 
    CloseFile(file)
end