/*-
 * Copyright (c) 1999 Takanori Watanabe <takawata@shidahara1.planet.sci.kobe-u.ac.jp>
 * Copyright (c) 1999, 2000 Mitsuru IWASAKI <iwasaki@FreeBSD.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	$FreeBSD$
 */

#ifndef _DEV_ACPI_ACPI_H_
#define _DEV_ACPI_ACPI_H_

/* 
 * PowerResource control 
 */
struct acpi_powerres_device {
	LIST_ENTRY(acpi_powerres_device) links;
	struct aml_name	*name;

	/* _PR[0-2] */
	u_int8_t		state;		/* D0 to D3 */
	u_int8_t		next_state;	/* initialized with D0 */
#define ACPI_D_STATE_D0		0
#define ACPI_D_STATE_D1		1
#define ACPI_D_STATE_D2		2
#define ACPI_D_STATE_D3		3
#define ACPI_D_STATE_UNKNOWN	255

	/* _PRW */
	u_int8_t		wake_cap;	/* wake capability */
#define ACPI_D_WAKECAP_DISABLE	0
#define ACPI_D_WAKECAP_ENABLE	1
#define ACPI_D_WAKECAP_UNKNOWN	255
#define ACPI_D_WAKECAP_DEFAULT	1 		/* XXX default enable for testing */

	boolean_t		gpe_enabled;	/* GEPx_EN enabled/disabled */
	union aml_object	*prw_val[2];	/* elements of _PRW package */
};

/* Device Power Management Chained Object Type */
#define ACPI_D_PM_TYPE_IRC	0		/* _IRC */
#define ACPI_D_PM_TYPE_PRW	1		/* _PRW */
#define ACPI_D_PM_TYPE_PRX	2		/* _PR0 - _PR2 */
/* and more... */

struct acpi_powerres_device_ref {
	LIST_ENTRY(acpi_powerres_device_ref) links;
	struct acpi_powerres_device	*device;
};

struct acpi_powerres_info {
	LIST_ENTRY(acpi_powerres_info) links;
	struct aml_name	*name;
	u_int8_t		state;		/* OFF or ON */
#define ACPI_POWER_RESOURCE_ON	1
#define ACPI_POWER_RESOURCE_OFF	0

#define ACPI_PR_MAX		3		/* _PR[0-2] */
	LIST_HEAD(, acpi_powerres_device_ref) reflist[ACPI_PR_MAX];
	LIST_HEAD(, acpi_powerres_device_ref) prwlist;
};

/*
 * Event Structure 
 */
struct acpi_event {
	STAILQ_ENTRY (acpi_event) ae_q;
	int ae_type;
#define ACPI_EVENT_TYPE_FIXEDREG 0
#define ACPI_EVENT_TYPE_GPEREG 1
#define ACPI_EVENT_TYPE_EC 2
	int ae_arg;
};

/* 
 * Softc 
*/
typedef struct acpi_softc {
	device_t	dev;
	dev_t		dev_t;

	struct resource	*port;
	int		port_rid;
	struct resource	*irq;
	int		irq_rid;
	void		*irq_handle;

	struct ACPIsdt	*rsdt;
	struct ACPIsdt	*facp;
	struct FACPbody	*facp_body;
	struct ACPIsdt	*dsdt;
	struct FACS	*facs;
	int		system_state;
	int		system_state_initialized;
	int		broken_wakeuplogic;
	u_int32_t	gpe0_mask;
	u_int32_t	gpe1_mask;
	int		enabled;
	u_int32_t	ignore_events;
	struct acpi_system_state_package system_state_package;
	struct proc	*acpi_thread;

	LIST_HEAD(, acpi_powerres_info) acpi_powerres_inflist;
	LIST_HEAD(, acpi_powerres_device) acpi_powerres_devlist;
	STAILQ_HEAD(, acpi_event) event;
} acpi_softc_t;

/* 
 * Device State 
 */
extern u_int8_t	 acpi_get_current_device_state(struct aml_name *name);
extern void	 acpi_set_device_state(acpi_softc_t *sc, struct aml_name *name,
				       u_int8_t state);
extern void	 acpi_set_device_wakecap(acpi_softc_t *sc, struct aml_name *name,
					 u_int8_t cap);

/* 
 * PowerResource State 
 */
extern void	acpi_powerres_init(acpi_softc_t *sc);
extern void	acpi_powerres_debug(acpi_softc_t *sc);
extern u_int8_t	acpi_get_current_powerres_state(struct aml_name *name);
extern void	acpi_set_powerres_state(acpi_softc_t *sc, struct aml_name *name,
					u_int8_t state);
extern void	acpi_powerres_set_sleeping_state(acpi_softc_t *sc, u_int8_t state);

/* 
 * GPE enable bit manipulation 
 */
extern void	acpi_gpe_enable_bit(acpi_softc_t *, u_int32_t, boolean_t);

/*
 * Event queue
 */
extern void	acpi_queue_event(acpi_softc_t *sc, int type, int arg);

/*
 * Debugging, console output
 *
 * XXX this should really be using device_printf
 */
extern int acpi_debug;
#define ACPI_DEVPRINTF(args...)		printf("acpi0: " args)
#define ACPI_DEBUGPRINT(args...)	do { if (acpi_debug) ACPI_DEVPRINTF(args);} while(0)

#endif	/* !_DEV_ACPI_ACPI_H_ */
