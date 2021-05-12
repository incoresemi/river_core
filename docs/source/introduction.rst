.. See LICENSE.incore for details
############
Introduction
############

**River Core** - The RISC-V Core Verification Framework is a Python based framework which enables testing of a variable RISC-V target (hard or soft implementations) against a configured set of reference models.
It aims to make the verification process for the designs as configurable as the RISC-V designs itself.


.. _intent:

Intent of the framework
=======================

The framework is intended to facilitate users and developers to verify the designs created in the huge configuration space RISC-V offers.
It provides an easy interface for managing verification of various designs.
It's plugin based approach allows users and developers can use existing generators, simulators and reference models along with the framework.

.. _audience:

Target Audience
===============

This document is targeted for the following categories of audience

Users
-----

RiVer Core, as a framework is targeted towards verification and design engineers who wish to test their design.
<CHECK: check this line>
RiVer Core is designed to be used a framework for the process of Constrained Random Verification [CRV], the most popular dynamic verification technique in practice today.

Contributors
------------

Enginners who would like to add more generators, simulators and reference models to enhance the framework, will be referred to as contributors/developers in the remaining sections of this
document. This framework enables engineers to author scalable and parameterized tests which can
evolve along.
