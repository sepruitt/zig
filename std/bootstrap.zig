import "syscall.zig";

// The compiler treats this file special by implicitly importing the function `main`
// from the root source file.

var argc: isize;
var argv: &&u8;
var env: &&u8;

#attribute("naked")
export fn _start() unreachable => {
    argc = asm("mov (%%rsp), %[argc]": [argc] "=r" (-> isize));
    argv = asm("lea 0x8(%%rsp), %[argv]": [argv] "=r" (-> &&u8));
    env = asm("lea 0x10(%%rsp,%%rdi,8), %[env]": [env] "=r" (-> &&u8));
    call_main()
}

fn strlen(ptr: &const u8) isize => {
    var count: isize = 0;
    while (ptr[count] != 0) {
        count += 1;
    }
    return count;
}

fn call_main() unreachable => {
    var args: [argc][]u8;
    for (arg, args, i) {
        const ptr = argv[i];
        args[i] = ptr[0...strlen(ptr)];
    }
    // TODO: replace the i32 cast with:
    // main(args) %% exit(1)
    // exit(0)
    exit(i32(main(args)))
}
