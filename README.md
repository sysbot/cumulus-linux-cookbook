Description
===========

This cookbook doesn't really do much. It's intented to create/simulate Cumulus
enviroment on a vanilla Debian to enchance Chef cookbook development. I.e. I 
need to use the same cookbook/recipes on the Cumulus switch but while developing
i'm doing it on a VM. So when implementing new features on Quagga for example
the ports and interfaces are not there.

Requirements
============

Knowledge and layout of a Cumulus switch

Attributes
==========

Usage
=====

include_recipe "cumulus::overlay"
