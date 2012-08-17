local _H = {
-------------------------------------------------------------------------------
PROJECT   = "xlib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "xlib.io.fs",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )  
local module = L.module
local config = L.config

-------------------------------------------------------------------------------

local _os, _assert, _type =  os, assert, type
local _lfs = module.load("lfs")

-------------------------------------------------------------------------------
--- <p><b>Module:</b> filesytem utility library.
-- Requires <i>luafilesystem</i>.
-- </p>
--
module("xlib.io.fs")
------------------------------------------------------------------------------

local UDS = config.SAFE_DIRSEP
local LDS = config.DIRSEP

--- Platform specific directory seperator. 
-- The seperator is extracted from <i>_G.package.config</i>.
dirsep = LDS

--- Encode file or directory path into universal form. The characters '/'
-- and '\' are replaced with a universal serperator. Trailing seperators are 
-- removed.
-- @param path path
-- @return encoded path 
function fnencode(path)
   _assert(_type(path)=='string')
   path = path:gsub("\\",UDS):gsub("/",UDS):gsub(UDS..UDS,UDS)
   :gsub(UDS.."$",""):gsub("^%s+",""):gsub("%s+$","")
   return path
end

--- Decode file or directory path into platform specific form. The universal
-- seperator is replaced with <i>dirsep</i>. 
-- @param path path
-- @param sep directory seperator (defaults to <i>dirsep()</i>) 
-- @return platform specific path
function fndecode(path, sep)
   sep = sep or LDS
   _assert(_type(path)=='string' and _type(sep)=='string')
   path = path:gsub(UDS,sep)
   return path
end

--- Convert path into platform specific form.
-- @param path file or directory path
-- @param sep directory seperator (defaults to <i>dirsep()</i>) 
-- @return platform specific path
function fnconvert(path,sep)
   return fndecode(fnencode(path),sep)
end

--- Combine encoded path segments to form spliced path.
-- @param ... encoded path segments
-- @return spliced path in encoded form
function fnsplice(...)
   local result = ""
   for i=1, select('#',...) do
      local part = select(i,...)
      _assert(_type(part)=='string')
      result = result..part..UDS
   end
   return fnenc(result)
end

--- Return a tuple of (base,dir,sfx) strings associated with file.
-- @param path encoded file/directory path
-- @return list of path components
function fnsplit(path)
   _assert(_type(path)=='string')
   return path:match("^(.-)([^"..UDS.."%.]*)([^"..UDS.."]-)$")
end

--- Rename file or directory.
-- @param oldname old name
-- @param newname new name
-- @return <tt>true</tt> if entity was renamed;
-- (<tt>nil</tt>, <i>error-string</i>) otherwise.
function rename(oldname,newname)
   local ok, err = _os.rename(oldname,newname)
   return ok,err
end

--- Retrieve file attributes. 
-- Attributes are 
-- <ul>
-- <li><tt>dev</tt>: the device the file resides on (Unix), or 
-- the drive number of the disk containing the file (Windows)</li>
-- <li><tt>ino</tt>: the inode number (Unix only)</li>
-- <li><tt>mode</tt>: protection mode string which has the value <i>file, 
-- directory, link, socket, named pipe, char device, block device</i> or 
-- <i>other</i></li>
-- <li><tt>nlink</tt>: number of hard links</li>
-- <li><tt>uid</tt>: uid of owner (Unix only, 0 on Windows)</li>
-- <li><tt>gid</tt>: gid of owner (Unix only, 0 on Windows)</li>
-- <li><tt>rdev</tt>: device type (Unix only, same as <i>dev</i> on Windows)</li>
-- <li><tt>access</tt>: time of last access</li>
-- <li><tt>modification</tt>: time of last modification</li>
-- <li><tt>change</tt>: time of last status change</li>
-- <li><tt>blocks</tt>: blocks allocated for file (Unix only)</li>
-- <li><tt>blksize</tt>: optimal file system I/O blocksize (Unix only)</li>
-- </ul> 
-- This function follows symbolic links to their destination. Use 
-- <i>symstat()</i> instead to retrieve information about symbolic links.
-- Requires <i>luafilesystem</i>.
-- @param filepath file path
-- @param aname attribute (optional)
-- @return <i>table</i> of file attributes or if <i>aname</i> is given a 
-- string which corresponds to <i>table.aname</i> 
function info(filepath,aname) 
   return _lfs.attributes(filepath,aname)
end

--- Retrieve symbolic link attributes (Unix only). Returned attributes are 
-- same as for <i>filestat()</i>.
-- Requires <i>luafilesystem</i>.
-- @param filepath file path
-- @param aname attribute (optional)
-- @return <i>table</i> of file attributes or if <i>aname</i> is given a 
-- string which corresponds to <i>table.aname</i> 
function syminfo(filepath,aname) 
   return _lfs.symlinkattributes(filepath,aname)
end

--- Touch existing file. 
-- Requires <i>luafilesystem</i>.
-- @param filepath file path 
-- @param atime access time (optional)
-- @param mtime modification time (optional)
-- @return <tt>true</tt> if file was touched; 
-- (<tt>nil</tt>, <i>error-string</i>) otherwise
function touch(filepath,atime,mtime) 
   return _lfs.touch(filepath,atime,mtime)
end

--- Create a directory. 
-- Requires <i>luafilesystem</i>.
-- @param dirpath directory path
-- @return <tt>true</tt> if directory was created; 
-- (<tt>nil</tt>, <i>error-string</i>) otherwise
function mkdir(dirpath)
   return _lfs.mkdir(dirpath)
end

--- Remove a directory. 
-- Requires <i>luafilesystem</i>.
-- @param dirpath directory path
-- @return <tt>true</tt> if directory was created; 
-- (<tt>nil</tt>, <i>error-string</i>) otherwise
function rmdir(dirpath)
   return _lfs.rmdir(dirpath)
end

--- Check whether path points to a directory. 
-- Requires <i>luafilesystem</i>.
-- @param path path
-- @return <tt>true</tt> if path points to a directory; 
-- <tt>false</tt> otherwise
function isdir(path)
   local att = info(path)
   if not att then return false end
   return att.mode == "directory"
end

--- Remove a file, symlink or empty directory. 
-- Requires <i>luafilesystem</i>.
-- @param path file/directory path
-- @return <tt>true</tt> if entity was removed; 
-- (<tt>nil</tt>, <i>error-string</i>) otherwise
function remove(path)
   -- fix: on Windows os.remove will not remove dirs! 
   if rmdir(path) then return true end 
   local ok, err = _os.remove(path)
   return ok, err
end

--- Change current working directory.
-- Requires <i>luafilesystem</i>.
-- @param dirpath directory path
-- @return <tt>true</tt> if successful; 
-- (<tt>nil</tt>, <i>error-string</i>) otherwise
function chdir(dirpath)
   return _lfs.chdir(dirpath)   
end

--- Return current working directory.
-- Requires <i>luafilesystem</i>.
-- @param dirpath directory path
-- @return current working directory; 
-- or (<tt>nil</tt>, <i>error-string</i>)
function getcwd(dirpath)
   return _lfs.currentdir(dirpath)   
end

--- Set writing mode for a file (Windows only). 
-- Requires <i>luafilesystem</i>.
-- @param filehandle file handle
-- @param mode file mode (<tt>binary</tt> or <tt>text</tt>)
-- @return <tt>true</tt> if operation successful; 
-- (<tt>nil</tt>, <i>error-string</i>) otherwise
function setmode(filehandle, mode)
   local ok,err = _lfs.setmode(filehandle, mode)      
   -- fix: setmode may inconsistenly return false instead of nil!
   if not ok then return nil,err end 
   return ok,err
end

--- Lock a file or part of it using the specified mode. 
-- If <i>offset</i>, <i>length</i> are specified then only that part of the 
-- file is locked.
-- Requires <i>luafilesystem</i>.
-- @param filehandle file handle
-- @param mode lock mode 
-- (<tt>r</tt> for read/shared lock or <tt>w</tt> for write/exclusive lock)
-- @param offset offset in bytes (optional)
-- @param length length in bytes (optional)
-- @return <tt>true</tt> if operation successful; 
-- (<tt>nil</tt>, <i>error-string</i>) otherwise
function lock(filehandle, mode, offset, length)
   local ok,err = _lfs.lock(filehandle, mode, offset, length)
   return ok,err
end

--- Unlock a file or part of it. 
-- If <i>offset</i>, <i>length</i> are specified then only that part of the 
-- file is unlocked.
-- Requires <i>luafilesystem</i>.
-- @param filehandle file handle
-- @param offset offset in bytes (optional)
-- @param length length in bytes (optional)
-- @return <tt>true</tt> if operation successful; 
-- (<tt>nil</tt>, <i>error-string</i>) otherwise
function unlock(filehandle, offset, length)
   local ok,err = _lfs.unlock(filehandle, offset, length)
   return ok,err
end

--- Create iterator over directory content. <i>dir(path)</i> returns a 
-- <i>next</i> function which on call returns one directory entry after the 
-- other until the content is exhausted (and it return <tt>nil</tt>).
-- @param dirpath directory path
-- @return <i>next</i> function; or <tt>nil</tt>, <i>error-str</i> if operation 
-- fails
function dir(dirpath)
   return _lfs.dir(dirpath)
end


------------------------------------------------------------------------------
