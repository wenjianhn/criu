define FEATURE_TEST_TCP_REPAIR

#include <netinet/tcp.h>

int main(void)
{
	struct tcp_repair_opt opts;
	opts.opt_code = TCP_NO_QUEUE;
	opts.opt_val = 0;

	return opts.opt_val;
}
endef

define FEATURE_TEST_TCP_REPAIR_WINDOW

#include <netinet/tcp.h>

int main(void)
{
	struct tcp_repair_window opts;

	opts.snd_wl1 = 0;

	return opts.snd_wl1;
}
endef

define FEATURE_TEST_LIBBSD_DEV
#include <bsd/string.h>

int main(void)
{
	return 0;
}
endef

define FEATURE_TEST_STRLCPY

#include <string.h>

#ifdef CONFIG_HAS_LIBBSD
# include <bsd/string.h>
#endif

int main(void)
{
	return strlcpy(NULL, NULL, 0);
}
endef

define FEATURE_TEST_STRLCAT

#include <string.h>

#ifdef CONFIG_HAS_LIBBSD
# include <bsd/string.h>
#endif

int main(void)
{
	return strlcat(NULL, NULL, 0);
}
endef

define FEATURE_TEST_PTRACE_PEEKSIGINFO

#include <sys/ptrace.h>

int main(void)
{
	struct ptrace_peeksiginfo_args args = {};

	return 0;
}

endef

define FEATURE_TEST_SETPROCTITLE_INIT

#include <bsd/unistd.h>

int main(int argc, char *argv[], char *envp[])
{
	setproctitle_init(argc, argv, envp);

	return 0;
}

endef

define FEATURE_TEST_X86_COMPAT
#define __ALIGN         .align 4, 0x90
#define ENTRY(name)             \
        .globl name;            \
        .type name, @function;  \
        __ALIGN;                \
        name:

#define END(sym)                \
        .size sym, . - sym

#define __USER32_CS     0x23
#define __USER_CS       0x33

        .text

ENTRY(call32_from_64)
        /* Switch into compatibility mode */
        pushq \$$__USER32_CS
        pushq \$$1f
        lretq
1:
        .code32
        /* Run function and switch back */
        call *%esi
        jmp \$$__USER_CS,\$$1f
        .code64
1:
END(call32_from_64)

ENTRY(main)
        nop
END(main)
endef
