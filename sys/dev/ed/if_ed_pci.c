/*
 *
 * Copyright (c) 1996 Stefan Esser <se@freebsd.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice immediately at the beginning of the file, without modification,
 *    this list of conditions, and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Absolutely no warranty of function or purpose is made by the author
 *    Stefan Esser.
 * 4. Modifications may be freely made to this file if the above conditions
 *    are met.
 *
 *	$Id: if_ed_p.c,v 1.2 1996/06/11 00:51:49 alex Exp $
 */

#include <pci.h>
#if NPCI > 0

#include <sys/param.h>
#include <sys/systm.h>
#include <sys/malloc.h>
#include <sys/kernel.h>
#include <pci/pcireg.h>
#include <pci/pcivar.h>
#ifdef PC98
#include <pc98/pc98/pc98_device.h>
#else
#include <i386/isa/isa_device.h>
#endif

#include <ed.h>

#define PCI_DEVICE_ID_NE2000	0x802910ec

extern void *ed_attach_NE2000_pci __P((int, int));

static char* ed_pci_probe __P((pcici_t tag, pcidi_t type));
static void ed_pci_attach __P((pcici_t config_id, int unit));

static u_long ed_pci_count = NED;

static struct pci_device ed_pci_driver = {
	"ed",
	ed_pci_probe,
	ed_pci_attach,
	&ed_pci_count,
	NULL
};

DATA_SET (pcidevice_set, ed_pci_driver);

static char*
ed_pci_probe (pcici_t tag, pcidi_t type)
{
	switch(type) {
	case PCI_DEVICE_ID_NE2000:
		return ("NE2000 compatible PCI Ethernet adapter");
		break;
	default:
		break;
	}
	return (0);
}

void edintr_sc (void*);

static void
ed_pci_attach(config_id, unit)
	pcici_t config_id;
	int	unit;
{
	u_long io_port;
	void *ed; /* device specific data ... */

	io_port = pci_conf_read(config_id, PCI_MAP_REG_START) & ~PCI_MAP_IO;

	ed = ed_attach_NE2000_pci(unit, io_port);
	if (!ed)
		return;

	if(!(pci_map_int(config_id, edintr_sc, (void *)ed, &net_imask))) {
		free (ed, M_DEVBUF);
		return;
	}

	return;
}

#endif /* NPCI > 0 */

