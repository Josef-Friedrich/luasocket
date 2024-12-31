---
---@meta
---The definitions are developed in this repository: https://github.com/LuaCATS/luasocket

---
---https://lunarmodules.github.io/luasocket/socket.html
---
---The socket namespace
---
---The `socket` namespace contains the core functionality of LuaSocket.
---
---To obtain the `socket` namespace, run:
---
---```lua
----- loads the socket module
---local socket = require("socket")
---```
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
---@class Socket
local socket = {}

---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
socket.headers = {}

---
---The `socket.headers.canonic` table
---is used by the HTTP and SMTP modules to translate from
---lowercase field names back into their canonic
---capitalization. When a lowercase field name exists as a key
---in this table, the associated value is substituted in
---whenever the field name is sent out.
---```
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
socket.headers.canonic = {}

---
---This constant is set to `true` if the library was compiled
---with debug support.
---
---@type boolean
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
socket._DEBUG = true

---
---Default datagram size used by calls to
---`receive`and
---`receivefrom`.
---(Unless changed in compile time, the value is 8192.)
---
---@type integer
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
socket._DATAGRAMSIZE = 8192

---
---Return the UNIX time in seconds.
---
---You should subtract the values returned by this function
---to get meaningful values.
---
---__Example:__
---
---```lua
---t = socket.gettime()
----- do stuff
---print(socket.gettime() - t .. " seconds elapsed")
---```
---
---__Reference:__
---
---* Corresponding C source code: [timeout.c#L190-L194](https://github.com/lunarmodules/luasocket/blob/8c2ff7217e2a205eb107a6f48b04ff1b2b3090a1/src/timeout.c#L190-L194)
---
---@return number time # for example `1683526723.1653`
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.gettime() end

---
---Creates and returns a clean
---`try`
---function that allows for cleanup before the exception
---is  raised.
---
---Note: This idea saved a lotof work with the
---implementation of protocols in LuaSocket:
---
---```lua
---foo = socket.protect(function()
---    -- connect somewhere
---    local c = socket.try(socket.connect("somewhere", 42))
---    -- create a try function that closes 'c' on error
---    local try = socket.newtry(function() c:close() end)
---    -- do everything reassured c will be closed
---    try(c:send("hello there?\r\n"))
---    local answer = try(c:receive())
---    ...
---    try(c:send("good bye\r\n"))
---    c:close()
---end)
---```
---
---@param finalizer function # -`Finalizer` is a function that will be called before `try` throws the exception.
---
---@return function # The function returns your customized `try` function.
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.newtry(finalizer) end

---
---Converts a function that throws exceptions into a safe function. This
---function only catches exceptions thrown by the `try`
---and `newtry`functions. It does not catch normal
---Lua errors.
---
---@param func function # `func` is a function that calls `try` (or `assert`, or `error`) to throw exceptions.
---
---@return function # Returns an equivalent function that instead of throwing exceptions in case of a failed `try`call, returns `nil` followed by an error message.
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.protect(func) end

---
---Waits for a number of sockets to change status.
---
--- `Recvt` and `sendt` can also
---be empty tables or `nil`. Non-socket values (or values with
---non-numeric indices) in the arrays will be silently ignored.
---
---The function returns a list with the sockets ready for
---reading, a list with the sockets ready for writing and an error message.
---The error message is "`timeout`" if a timeout
---condition was met, "`select failed`" if the call
---to `select` failed, and
---`nil` otherwise. The returned tables are
---doubly keyed both by integers and also by the sockets
---themselves, to simplify the test if a specific socket has
---changed status.
---
---Note:`select` can monitor a limited number
---of sockets, as defined by the constant
---`socket._SETSIZE`. This
---number may be as high as 1024 or as low as 64 by default,
---depending on the system. It is usually possible to change this
---at compile time. Invoking `select` with a larger
---number of sockets will raise an error.
---
---Important note: a known bug in WinSock causes `select` to fail
---on non-blocking TCP sockets. The function may return a socket as
---writable even though the socket is notready for sending.
---
---Another important note: calling select with a server socket in the receive parameter before a call to accept does notguarantee
---`accept`will return immediately.
---Use the `settimeout`
---method or `accept` might block forever.
---
---Yet another note: If you close a socket and pass
---it to `select`, it will be ignored.
---
---Using select with non-socket objects: Any object that implements `getfd` and `dirty` can be used with `select`, allowing objects from other libraries to be used within a `socket.select` driven loop.
---
---@param recvt table|nil # `recvt` is an array with the sockets to test for characters available for reading.
---@param sendt table|nil # Sockets in the `sendt` array are watched to see if it is OK to immediately write on them.
---@param timeout? integer # `timeout` is the
---maximum amount of time (in seconds) to wait for a change in status.  A
---`nil`, negative or omitted `timeout` value allows the
---function to block indefinitely.
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.select(recvt, sendt, timeout) end

---
---The maximum number of sockets that the select function can handle.
---
---@type integer
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
socket._SETSIZE = 0

---
---Creates an
---LTN12
---sink from a stream socket object.
---
---`Mode` defines the behavior of the sink. The following
---options are available:
---
---* `"http-chunked"`: sends data through socket after applying the
---chunked transfer coding, closing the socket when done;
---* `"close-when-done"`: sends all received data through the
---socket, closing the socket when done;
---* `"keep-open"`: sends all received data through the
---socket, leaving it open when done.
---
---`Socket` is the stream socket object used to send the data.
---
---The function returns a sink with the appropriate behavior.
---
---@param mode 'http-chunked'|'close-when-done'|'keep-open'
---@param socket any
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.sink(mode, socket) end

---
---Drops a number of arguments and returns the remaining.
---
---`D` is the number of arguments to drop. `Ret1` to
---`retN` are the arguments.
---
---The function returns `retd+1` to `retN`.
---
---Note: This function is useful to avoid creation of dummy variables:
---
---```
----- get the status code and separator from SMTP server reply
---local code, sep = socket.skip(2, string.find(line, "^(%d%d%d)(.?)"))
---```
---
---@param d integer
---@param ... any
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.skip(d, ...) end

---
---Freeze the program execution during a given amount of time.
---
---__Reference:__
---
---* Corresponding C source code: [timeout.c#L196-L226](https://github.com/lunarmodules/luasocket/blob/8c2ff7217e2a205eb107a6f48b04ff1b2b3090a1/src/timeout.c#L196-L226)
---
---@param time integer # `time` is the number of seconds to sleep for. If `time` is negative, the function returns immediately.
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.sleep(time) end

---
---Creates an
---LTN12
---source from a stream socket object.
---
---`Mode` defines the behavior of the source. The following
---options are available:
---
---* `"http-chunked"`: receives data from socket and removes the
---chunked transfer codingbefore returning the data;
---* `"by-length"`: receives a fixed number of bytes from the
---socket. This mode requires the extra argument `length`;
---* `"until-closed"`: receives data from a socket until the other
---side closes the connection.
---
---`Socket` is the stream socket object used to receive the data.
---
---The function returns a source with the appropriate behavior.
---
---@param mode 'http-chunked'|'by-length'|'until-closed'
---@param socket any
---@param timeout integer
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.source(mode, socket, timeout) end

---
---The OS value for an invalid socket. This can be used with
---`tcp:getfd`and `tcp:setfd`methods.
---@type any
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
socket._SOCKETINVALID = nil

---
---Throws an exception in case `ret1` is falsy, using
---`ret2` as the error message. The exception is supposed to be caught
---by a `protect`ed function only.
---
---`Ret1` to `retN` can be arbitrary
---arguments, but are usually the return values of a function call
---nested with `try`.
---
---The function returns `ret`1 to `ret`N if
---`ret`1 is not `nil` or `false`.
---Otherwise, it calls `error` passing `ret`2 wrapped
---in a table with metatable used by `protect`to
---distinguish exceptions from runtime errors.
---
---```lua
----- connects or throws an exception with the appropriate error message
---c = socket.try(socket.connect("localhost", 80))
---```
---
---@param ... any
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.try(...) end

---
---This constant has a string describing the current LuaSocket version.
---@type string
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
socket._VERSION = ""

--{{{ TCP
--#region TCP

---
---@class TCPSocketMaster
local tcp_master = {}

---
---@class TCPSocketServer : TCPSocketMaster
local tcp_server = {}

---
---@class TCPSocketClient : TCPSocketMaster
local tcp_client = {}

---
---Waits for a remote connection on the server object and returns a client object representing that connection.
---
---If a connection is successfully initiated, a client object is returned. If a timeout condition is met, the method returns `nil` followed by the error string 'timeout'. Other errors are reported by `nil` followed by a message describing the error.
---
---Note: calling `socket.select` with a server object in the recvt parameter before a call to accept does not guarantee accept will return immediately. Use the `settimeout` method or accept might block until another client shows up.
---
---@return TCPSocketClient | nil, "timeout" | string
function tcp_server:accept() end

---
---Binds a master object to address and port on the local host.
---
---Address can be an IP address or a host name. Port must be an integer number in the range [0..64K). If address is `'*'`, the system binds to all local interfaces using the `INADDR_ANY` constant or `IN6ADDR_ANY_INIT`, according to the family. If `port` is `0`, the system automatically chooses an ephemeral port.
---
---In case of success, the method returns `1`. In case of error, the method returns `nil` followed by an error message.
---
---On success, the type changes to `TCPSocketServer`, and you should cast it as such.
---
---Note: The function `socket.bind` is available and is a shortcut for the creation of server sockets.
---
---@param address string
---@param port integer
---@return 1|nil, nil|string
function tcp_master:bind(address, port) end

---
---Closes a TCP object.
---The internal socket used by the object is closed and the local address to which the object was bound is made available to other applications.
---No further operations (except for further calls to the close method) are allowed on a closed socket.
---
---Note: It is important to close all used sockets once they are not needed, since, in many systems,
---each socket uses a file descriptor, which are limited system resources.
---Garbage-collected objects are automatically closed before destruction, though.
function tcp_master:close() end

---
---Attempts to connect a master object to a remote host, transforming it into a client object.
---Client objects support methods `send`, `receive`, `getsockname`, `getpeername`, `settimeout`, and `close`.
---
---On success, the type changes to `TCPClient`, and you should cast it as such.
---
---Note: The function `socket.connect` is available and is a shortcut for the creation of client sockets.
---Note: Starting with LuaSocket 2.0, the `settimeout` method affects the behavior of connect, causing it to return with an error in case of a timeout. If that happens, you can still call socket.select with the socket in the sendt table. The socket will be writable when the connection is established.
---Note: Starting with LuaSocket 3.0, the host name resolution depends on whether the socket was created by socket.tcp, socket.tcp4 or socket.tcp6. Addresses from the appropriate family (or both) are tried in the order returned by the resolver until the first success or until the last failure. If the timeout was set to zero, only the first address is tried.
---
---@param address string # IP address or a host name
---@param port integer # TCP port, in the range [1..64K)
---@return nil | 1, nil | string # In case of error, the method returns nil followed by a string describing the error. In case of success, the method returns 1.
function tcp_master:connect(address, port) end

---
---Check the read buffer status.
---
---**Note: This is an internal method, use at your own risk.**
---@return boolean # `true` if there is any data in the read buffer, `false` otherwise.
function tcp_master:dirty() end

---
---Get the underling socket descriptor or handle associated to the object.
---
---**Note: This is an internal method. Unlikely to be portable. use at your own risk.**
---@return integer # The descriptor or handle. `-1` if the object has been closed. `_SOCKETINVALID` if it is an invalid socket.
function tcp_master:getfd() end

---@alias TCPOption
---| "keepalive" Setting this option to `true` enables the periodic transmission of messages on a connected socket. Should the connected party fail to respond to these messages, the connection is considered broken and processes using the socket are notified;
---| "linger" Controls the action taken when unsent data are queued on a socket and a close is performed. The value is a table with a boolean entry `on` and a numeric entry for the time interval `timeout` in seconds. If the `on` field is set to `true`, the system will block the process on the close attempt until it is able to transmit the data or until `timeout` has passed. If `on` is `false` and a `close` is issued, the system will process the `close` in a manner that allows the process to continue as quickly as possible. I do not advise you to set this to anything other than zero;
---| "reuseaddr" Setting this option indicates that the rules used in validating addresses supplied in a call to bind should allow reuse of local addresses;
---| "tcp-nodelay" Setting this option to `true` disables the Nagle's algorithm for the connection;
---| "tcp-keepidle" value in seconds for `TCP_KEEPIDLE` **Linux only!!**
---| "tcp-keepcnt" value for `TCP_KEEPCNT` **Linux only!!**
---| "tcp-keepintvl" value for `TCP_KEEPINTVL` **Linux only!!**
---| "tcp-defer-accept" value for `TCP_DEFER_ACCEPT` **Linux only!!**
---| "tcp-fastopen" value for `TCP_FASTOPEN` **Linux only!!**
---| "tcp-fastopen-connect" value for `TCP_FASTOPEN_CONNECT` **Linux only!!**
---| "ipv6-v6only" Setting this option to `true` restricts an inet6 socket to sending and receiving only IPv6 packets.
--- The descriptions above come from the man pages.

---
---Gets options for the TCP object. See `setoption` for description of the option names and values.
---@param option TCPOption
---@return any | nil, nil | string # The option value in case of success, or nil followed by an error message otherwise.
function tcp_client:getoption(option) end

---
---Gets options for the TCP object. See `setoption` for description of the option names and values.
---@param option TCPOption
---@return any | nil, nil | string # The option value in case of success, or nil followed by an error message otherwise.
function tcp_server:getoption(option) end

---@alias SocketFamily
---| "inet" IPv4
---| "inet6" IPv6
---| "unspec" Unspecified
---| "unknown" Unknown

---
---Returns information about the remote side of a connected client object.
---
---Note: It makes no sense to call this method on server objects.
---
---@return string | nil, integer | nil, SocketFamily | nil # The IP address of the peer, the port number that the peer is using for the connection, and the family. In case of error, returns `nil`.
---
function tcp_client:getpeername() end

---
---Returns the local address information associated to the object.
---
---@return string | nil, integer | nil, SocketFamily | nil # The IP address of the peer, the port number that the peer is using for the connection, and the family. In case of error, returns `nil`.
function tcp_master:getsockname() end

---
---Returns the current block timeout followed by the current total timeout.
---
---@return number, number # Current block timeout, current total timeout.
function tcp_master:gettimeout() end

---
---Specifies the socket is willing to receive connections, transforming the object into a server object. Server objects support the `accept`, `getsockname`, `setoption`, `settimeout`, and `close` methods.
---
---On success, the type changes to `TCPSocketServer`, and you should cast it as such.
---
---@param backlog integer The number number of client connections that can be queued waiting for service. If the queue is full and another client attempts connection, the connection is refused.
---
---@return 1 | nil, nil | string # Returns 1 on success, nil and an error on failure.
---
function tcp_master:listen(backlog) end

---@alias SocketError
---| "timeout" If there was a timeout during the operation.
---| "closed" If the connection was closed before the transmission was completed.

-- HACK: For some reason number doesn't show up in the completion if it's
--       defined as part of this union. It should be defined in-place.

---
---@alias ReceivePatternMode
---| '*a' # Reads from the socket until the connection is closed. No end-of-line translation is performed
---| '*l' # Reads a line of text from the socket. The line is terminated by a LF character (ASCII 10), optionally preceded by a CR character (ASCII 13). The CR and LF characters are not included in the returned line. In fact, all CR characters are ignored by the pattern.

---
---Reads data from a client object, according to the specified read pattern. Patterns follow the Lua file I/O format, and the difference in performance between all patterns is negligible.
---
---**Important note:** This function was changed severely. It used to support multiple patterns (but I have never seen this feature used) and now it doesn't anymore. Partial results used to be returned in the same way as successful results. This last feature violated the idea that all functions should return nil on error. Thus it was changed too.
---
---@param pattern? ReceivePatternMode | number The default is "*l"
---@param prefix? string Optional string to be concatenated to the beginning of any received data before return.
---
---@return string | nil, SocketError | string | nil # Returns the received pattern when successful, otherwise nil and an error message.
function tcp_client:receive(pattern, prefix) end

---
---Sends data through client object.
---
---The optional arguments `i` and `j` work exactly like the standard `string.sub` Lua function to allow the selection of a substring to be sent.
---
---**Note:** Output is not buffered. For small strings, it is always better to concatenate them in Lua (with the '..' operator) and send the result in one call instead of calling the method several times.
---
---@param data string The string to be sent.
---@param i? integer
---@param j? integer
---@return integer | nil, SocketError | string | nil, integer | nil # On success the number of bytes sent, otherwise nil followed by an error message, followed by the index of the last byte within `[i, j]` that has been sent. You might want to try again from the byte following that.
function tcp_client:send(data, i, j) end

---
---Sets options for the TCP object. Options are only needed by low-level or time-critical applications. You should only modify an option if you are sure you need it.
---
---@param option TCPOption A string with the option name
---@param value? any Depends on the option being set
---@return 1 | nil, string | nil # 1 on success, nil and an error message otherwise.
function tcp_client:setoption(option, value) end

---
---Sets options for the TCP object. Options are only needed by low-level or time-critical applications. You should only modify an option if you are sure you need it.
---
---@param option TCPOption A string with the option name
---@param value? any Depends on the option being set
---@return 1 | nil, string | nil # 1 on success, nil and an error message otherwise.
function tcp_server:setoption(option, value) end

---
---Resets accounting information on the socket, useful for throttling of bandwidth.
---
---@param received number Bytes received
---@param sent number Byte sent
---@param age number Age in seconds
---@return 1 | nil # 1 on success, nil otherwise.
function tcp_master:setstats(received, sent, age) end

---@alias TCPTimeoutMode
---| "b" block timeout. Specifies the upper limit on the amount of time LuaSocket can be blocked by the operating system while waiting for completion of any single I/O operation.
---| "t" total timeout. Specifies the upper limit on the amount of time LuaSocket can block a Lua script before returning from a call.

---
---Changes the timeout values for the object. By default, all I/O operations are blocking. That is, any call to the methods `send`, `receive`, and `accept` will block indefinitely, until the operation completes. The `settimeout` method defines a limit on the amount of time the I/O methods can block. When a timeout is set and the specified amount of time has elapsed, the affected methods give up and fail with an error code.
---
---**Note:** although timeout values have millisecond precision in LuaSocket, large blocks can cause I/O functions not to respect timeout values due to the time the library takes to transfer blocks to and from the OS and to and from the Lua interpreter. Also, function that accept host names and perform automatic name resolution might be blocked by the resolver for longer than the specified timeout value.
---
---**Note:** The old timeout method is deprecated. The name has been changed for sake of uniformity, since all other method names already contained verbs making their imperative nature obvious.
---
---@param value number | nil Time to wait, in seconds. Use `nil` or negative to block indefinitely.
---@param mode? TCPTimeoutMode The default mode is "b"
function tcp_master:settimeout(value, mode) end

---@alias TCPShutdownMode
---| "both" Disallow further sends and receives on the object.
---| "send" Disallow further sends on the object.
---| "receive" Disallow further receives on the object.

---
---Shuts down part of a full-duplex connection.
---@param mode TCPShutdownMode Determines which way of the connection should be shut down.
---@return 1 # Always returns 1.
function tcp_client:shutdown(mode) end

---
---Sets the underling socket descriptor or handle associated to the object. The current one is simply replaced, not closed, and no other change to the object state is made. To set it as invalid use `_SOCKETINVALID`.
---
---**Note: This is an internal method. Unlikely to be portable. Use at your own risk.**
---
---@param fd integer
function tcp_master:setfd(fd) end

-- The following are in the socket namespace --

---
---This function is a shortcut that creates and returns a TCP server object bound to a local `address` and `port`, ready to accept client connections. Optionally, user can also specify the `backlog` argument to the `listen` method.
---
---Note: The server object returned will have the option `reuseaddr` set to `true`.
---
---@param address string
---@param port integer
---@param backlog? integer Defaults to 32.
---@return TCPSocketServer
---
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.bind(address, port, backlog) end

---
---This function is a shortcut that creates and returns a TCP client object connected to a remote `address` at a given `port`. Optionally, the user can also specify the local address and port to bind (`locaddr` and `locport`), or restrict the socket family to "`inet`" or "`inet6`".
---
---Two variations of connect are defined as simple helper functions that restrict the `family`, `socket.connect4` and `socket.connect6`.
---
---@param address string
---@param port integer
---@param locaddr? string The local address
---@param locport? integer The local port
---@param family? 'inet'|'inet6' If not specified, the family depends on your system configuration.
---@return TCPSocketClient | nil, nil | string # Returns the client on success, or `nil` and an error message on failure.
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.connect(address, port, locaddr, locport, family) end

---
---This function is a shortcut that creates and returns an IPv4 TCP client object connected to a remote `address` at a given `port`. Optionally, the user can also specify the local address and port to bind (`locaddr` and `locport`)
---
---@param address string
---@param port integer
---@param locaddr? string The local address
---@param locport? integer The local port
---
---@return TCPSocketClient | nil, nil | string # Returns the client on success, or `nil` and an error message on failure.
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.connect4(address, port, locaddr, locport) end

---
---This function is a shortcut that creates and returns an IPv6 TCP client object connected to a remote `address` at a given `port`. Optionally, the user can also specify the local address and port to bind (`locaddr` and `locport`)
---
---@param address string
---@param port integer
---@param locaddr? string The local address
---@param locport? integer The local port
---
---@return TCPSocketClient | nil, nil | string # Returns the client on success, or `nil` and an error message on failure.
---😱 [Types](https://github.com/LuaCATS/luasocket/blob/main/library/socket.lua) incomplete or incorrect? 🙏 [Please contribute!](https://github.com/LuaCATS/luasocket/pulls)
function socket.connect6(address, port, locaddr, locport) end

---
---Creates and returns an TCP master object. A master object can be transformed into a server object with the method `listen` (after a call to `bind`) or into a client object with the method `connect`. The only other method supported by a master object is the close method.
---
---Note: The choice between IPv4 and IPv6 happens during a call to `bind` or `connect`, depending on the address family obtained from the resolver.
---
---Note: Before the choice between IPv4 and IPv6 happens, the internal socket object is invalid and therefore `setoption` will fail.
---
---@return TCPSocketMaster | nil, nil | string # New master object if successful, otherwise `nil` followed by an error message.
function socket.tcp() end

---
---Creates and returns an IPv4 TCP master object. A master object can be transformed into a server object with the method `listen` (after a call to `bind`) or into a client object with the method connect. The only other method supported by a master object is the `close` method.
---
---@return TCPSocketMaster | nil, nil | string # New master object if successful, otherwise `nil` followed by an error message.
function socket.tcp4() end

---
---Creates and returns an IPv6 TCP master object. A master object can be transformed into a server object with the method `listen` (after a call to `bind`) or into a client object with the method `connect`. The only other method supported by a master object is the `close` method.
---
---Note: The TCP object returned will have the option "ipv6-v6only" set to `true`.
---
---@return TCPSocketMaster | nil, nil | string # New master object if successful, otherwise `nil` followed by an error message.
function socket.tcp6() end

--#endregion
--}}}

return socket
