#include <asm.h>

ENTRY(syscall_sysenter)
	push %ecx
	push %edx
	push $SYSENTER_RETURN
	push %ebp
	mov %esp, %ebp
	sysenter
ENTRY(SYSENTER_RETURN)
	pop %ebp
	pop %edx
	pop %edx
	pop %ecx
	ret

/* int write(int fd, char *buffer, int size) */
ENTRY(write)
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx;  // Save EBX, ESI and EDI if modified
	movl $4, %eax
	movl 0x8(%ebp), %ebx;	//fd
	movl 0xC(%ebp), %ecx;	//buffer
	movl 0x10(%ebp), %edx;	//size
	call syscall_sysenter
	popl %ebx
	test %eax, %eax
	js nok	// if (eax < 0) -> 
	popl %ebp
	ret

/* Common code for negative return */
nok:
	neg %eax
	mov %eax, errno
	mov $-1, %eax
	popl %ebp
	ret

/* int gettime() */
ENTRY(gettime)
	pushl %ebp
	movl %esp, %ebp
	movl $10, %eax
	call syscall_sysenter
	popl %ebp
	ret

/* int getpid() */
ENTRY(getpid)
	pushl %ebp
	movl %esp, %ebp
	movl $20, %eax
	call syscall_sysenter
	popl %ebp
	ret

/* int fork() */
ENTRY(fork)
	pushl %ebp
	movl %esp, %ebp
	movl $2, %eax
	call syscall_sysenter
	test %eax, %eax
	js nok	// if (eax < 0) -->
	popl %ebp
	ret

/* void exit() */
ENTRY(exit)
	pushl %ebp
	movl %esp, %ebp
	movl $1, %eax
	call syscall_sysenter
	popl %ebp
	ret

/* int yield() */
ENTRY(yield)
	pushl %ebp
	movl %esp, %ebp
	movl $13, %eax
	call syscall_sysenter
	popl %ebp
	ret

/* int get_stats(int pid, struct stats *st) */
ENTRY(get_stats)
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx;  // Save EBX, ESI and EDI if modified
	movl $35, %eax
	movl 0x8(%ebp), %ebx;	//pid
	movl 0xC(%ebp), %ecx;	//st
	call syscall_sysenter
	popl %ebx
	test %eax, %eax
	js nok	// if (eax < 0) -->
	popl %ebp
	ret

/* int get_key(char* c) */
ENTRY(get_key)
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx;  // Save EBX, ESI and EDI if modified
	movl $0, %eax
	movl 0x8(%ebp), %ebx;	//char* c
	movl 0xC(%ebp), %ecx;	//int block
	call syscall_sysenter
	popl %ebx;
	test %eax, %eax
	js nok	// if (eax < 0) -->
	popl %ebp
	ret

/* int set_screen_callback(char *(*callback_function)(char*)) */
ENTRY(set_screen_callback)
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx;  // Save EBX, ESI and EDI if modified
	movl $7, %eax
	movl 0x8(%ebp), %ebx;	//char *(*callback_function)(char*)
	call syscall_sysenter
	popl %ebx;
	test %eax, %eax
	js nok	// if (eax < 0) -->
	popl %ebp
	ret

/* int restore_ctx() */
ENTRY(restore_ctx)
	pushl %ebp
	movl %esp, %ebp
	movl $11, %eax
	call syscall_sysenter
	test %eax, %eax
	js nok	// if (eax < 0) -->
	popl %ebp
	ret

/* char* get_big()*/
ENTRY(get_big)
	pushl %ebp
	movl %esp, %ebp
	movl $5, %eax
	call syscall_sysenter
	popl %ebp
	ret

/* int free_big(char *s)*/
ENTRY(free_big)
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx;  // Save EBX, ESI and EDI if modified
	movl $6, %eax
	movl 0x8(%ebp), %ebx;	//char *s
	call syscall_sysenter
	popl %ebx;
	test %eax, %eax
	js nok	// if (eax < 0) -->
	popl %ebp
	ret