ICAM V24.2 Release
******************

These release notes describe the most significant V24.2 enhancements and
problem corrections.

Some of the enhancements and many of the problem corrections are also
available in updated releases of V23. If so, the release build number is
listed at the end of the enhancement or problem description in
[V\ *vv*-*yyww*] format, where *vv* is the version, *yy* is the year and
*ww* is the week (1-52).

We hope you enjoy your new release of the ICAM products and we sincerely
welcome your feedback.

*The CGTech ICAM R&D Team
August 30, 2023*

Systems and Packaging
---------------------

Product Availability
~~~~~~~~~~~~~~~~~~~~

+----------------------------------+-----------------------------------+
| System Manufacturer              | O/S Minimum Requirement           |
+----------------------------------+-----------------------------------+
| Microsoft Windows 32-bit*\*      | 10, 11                            |
+----------------------------------+-----------------------------------+
| Microsoft Windows 64-bit         | 10, 11, 2016, 2019, 2022          |
+----------------------------------+-----------------------------------+

ICAM software is not available for UNIX systems. An ICAM database
created with V20 or earlier on a UNIX system is fully compatible with
ICAM software running on Windows systems.

ICAM V24.2 can run under Microsoft Windows 7, 8 and 8.1, and Microsoft
Windows Server 2008R2, 2012 and 2012R2, but these operating systems are
no longer supported by Microsoft.

\*\* V24.x are the final versions supporting 32-bit architectures. The
32-bit installers are available with V24.x on demand only. Contact
support@icam.com should you require a 32-bit installation. Note that
there is no performance benefit to using 32-bit, but there is a
disadvantage with 32-bit of having less available memory for a running
process.

Productivity Tools
------------------

Quest D\ eveloper’s
~~~~~~~~~~~~~~~~~~~

-  Mill-Turn support exchangeable heads. Add support of heads in
   questionnaire and in GENER. The turret questionnaire section now
   allow to define head attachment (Starting at question #200.00)

-  A new *Tools»Consistency* menu selection (CTRL+SHIFT+G shortcut) is
   available to check the post-processor and control emulator for
   inconsistencies before Generating. Inconsistencies are listed in a
   new *Consistency* tab. This includes any question whose response
   differs from the selected basic machine or basic control, as defined
   in *General Description / General Information* questions #4 “Machine
   defaults” and #5 “Control defaults”. It also includes all
   inconsistencies that would appear during a Generate. The F4 and
   SHIFT+F4 keyboard shortcuts can be used to iterate through the
   inconsistencies listed in the *Consistency* tab.

During consistency checking, QUEST now checks RMD actions to see if the
macro text of selected actions is out-of-date and should be updated.
Note that the Siemens and Heidenhain cycle RMD actions have been updated
for V24.2 and any post using an older version of these RMD actions will
now indicate an inconsistency when running the new Consistency function
or when Generating.

-  The *Gener Description / General Information* question #4 “Machine
   defaults” dialog now includes an option to browse to a folder where
   XML definition files have been exported from CGTech VERICUT VMCs. The
   machine definitions exported from VERICUT will then be listed and can
   be selected. The New Post wizard also can select the VERICUT
   definition file. This makes it possible to check for inconsistencies
   between the kinematics of a VMC and that of the post-processor.

-  The *Automated Canned Cycles / Drill Cycles* section has been
   enhanced and reorganized to improve floating tap, and to support new
   rigid tap and back-bore cycles:

-  New question #31 “Reverse TAP-FLOAT cycle available” supports the
   case where the same G code is used for both left and right hand
   tapping, with the spindle direction controlling the tap direction.

-  Rigid tapping (TAP-RIGID cycle) is now available and can be defined
   in various ways. This includes the definition of a rigid tap enable
   mode code (e.g. M29) before the normal tap cycle G code, and/or the
   inclusion of a tap cycle type register with the normal tap cycle G
   code. Alternately, rigid tapping can be defined with a cycle G code
   that is different from that of the float tap cycle.

-  Reverse rigid tapping has the option to use the same cycle G code as
   normal rigid tapping, but with the left vs. right hand direction
   controlled either by the spindle direction or the sign of the cycle
   pitch (feed) register.

-  New deep (TAP-DEEP) and chip-break (TAP-BRKCHP) rigid tapping cycles
   can be defined. The inverse variation of these cycles can be defined
   with their own cycle G codes, or by the spindle direction, or by the
   sign of the cycle pitch register. Stepped tapping cycles share the
   same step increment, step decrement and back-step information as the
   stepped drilling cycles.

-  A “TAP information” tab includes additional float and rigid tap
   questions.

-  #200 “Default TAP format” defines the tap format to use, either FLOAT
   or RIGID, if it is not specified on the CYCLE command.

-  #201.1 and #201.2 define the default speed multiplier to be used when
   positioning during float and rigid tap cycles. This also can be
   specified on the CYCLE command using a new RATIO,\ *value* parameter,
   or in macros using a new $CYRATIO variable. The ratio is used for
   simulation and timing purposes only.

-  #202 “Rigid tap orient angle control” defines the ability of the CNC
   to orient the spindle at the start of a rigid tap cycle.

-  #206.1 and #206.2 determine if the spindle RPM must be output before
   normal and stepped rigid tap cycles.

-  Back-boring (BORE-BACK cycle) is now available. Back boring shares
   the same spindle orientation and jog clearance information as the
   BORE with ORIENT cycle. Generally the R plane defines the lower
   clearance plane of a back-boring cycle, but it is also possible to
   define a separate register for this cycle plane.

-  The Cycle Startup macro Siemens and Heidenhain RMD actions have been
   enhanced as follows:

-  The Siemens cycle RMD action no longer prompts for the TAP cycle to
   use, because the macro now supports both CYCLE840 float and CYCLE84
   rigid tap cycles. The CYCLE84 rigid cycle has been enhanced to
   support deep and chip-break tapping.

The RMD action also no longer prompts for the REAM cycle to use, because
the macro now uses CYCLE85 if a RATIO greater than 1 is specified on the
CYCLE command, otherwise it uses CYCLE89.

Siemens does not support back boring. If this cycle is not set to
“Simulate” in QUEST, then the macro will output a diagnostic if a
back-bore cycle is requested.

-  The Heidenhain ISO and Conversational RMD actions no longer prompt
   for the TAP cycle to use, because the macros now support G206
   TAPPING, G207 RIGID TAPPING and G209 TAPPING W/ CHIP BRKG cycles.

The RMD action also now supports the G204 BACK BORING cycle.

Gener Post-processing
~~~~~~~~~~~~~~~~~~~~~

-  A new CYCLE/BORE,BACK command is available to output a back-bore
   cycle. The RAPTO parameter is required for this cycle type, and
   defines the lower clearance plane, measured from the control point.

|image1|

-  The CYCLE/REAM command now supports an optional RATIO\ *,value*
   parameter to define the feed multiplier to use when pulling out of
   the hole. The ratio is available via a new $CYRATIO variable, which
   can be changed in macro processing, and which affects timing and
   Virtual Machine simulation.

|image2|

-  The CYCLE/TAP command now supports an optional FLOAT or RIGID
   keyword, immediately following TAP, to explicitly define a floating
   or rigid tap cycle. I neither FLOAT or RIGID is specified, then the
   cycle type is defined by the response to
   *Automated Canned Cycles / Drill Cycles* question #200 “\ *Default
   TAP format*\ ”.

|image3|

The TAP cycle now supports an optional RATIO\ *,value* parameter to
define the spindle and feed multiplier to use when pulling out of the
hole. The tap feed can also now be defined using TPI\ *,f*. The
TAP-RIGID cycle supports optional ORIENT\ *,angle* and MULTRD\ *,starts*
parameters to define the initial spindle orient at the start of the
cycle, and the number of thread starts required. If a spindle orient is
not available with rigid tapping, then multiple starts are implemented
by adjusting the R plane downwards for each successive start.

-  New CYCLE/TAP,DEEP and CYCLE/TAP,BRKCHP commands are available to
   output deep-hole and chip-breaking rigid tap cycles. The syntax is
   similar to the drilling deep-hole and chip-breaking cycles, except
   that only a single feed parameter is allowed, and they support the
   same TPI, RATIO, ORIENT and MULTRD parameters as the TAP-RIGID cycle.

|image4|\ |image5|

-  The drilling deep-hole and chip-break cycles now support an optional
   DRILL keyword before the DEEP or BRKCHP keywords. This is done to be
   consistent with the new TAP-DEEP and TAP-BRKCHP cycles.

-  Drilling and tapping DEEP and BRKCHP secondary clearance values are
   now used for timing and simulation purposes only. Previously, if the
   CYCLE/DEEP or CYCLE/BRKCHP command defined a secondary clearance that
   did not match the QUEST defined value, then the cycle was output
   point-to-point. Note that a post-processor must be upgraded to V24.2
   using QUEST for this enhancement to take effect.

If the CNC has a known fixed value for secondary clearance, then $CYCLRS
macro variable can be set to that value in a Cycle Startup macro to
obtain more accurate timing and simulation.

-  LIMIT/POLAR Path Planning travel optimization for CYCLE.

-  A new MPGOTO "Multi-point GOTO" DEF file variable has been added to
   the Config Utility "CAM Interface" panel. This variable controls
   whether or not 5000-class motion records can contain multiple points.
   This should have no effect on CAM-POST processing, but it will affect
   user-defined macro matching of 5000 class records

-  LIMIT/POLAR Path Planning - RTA -SmartPATH combination.

-  G29 is now supported in incremental positioning mode.

-  High Speed Machining (HSM) license can now be used to report motion
   time corrected by various factors like machine
   acceleration/deceleration capabilities, High feed, RAPID positioning
   and interpolation mode. The output NC program is not affected but
   reported motion time is closer to the real machining time.

| Setting the post processor requires setting parameters listed in HSM
  section, and selecting MCHTOL command parameters by comparing CAM-POST
  results to a couple of real machining examples for which the customer
  should measure the real machining time.
| HSM analysis for cutting (Feed motions), High Feed positioning (HF
  motions) and RAPID positioning motion is possible. Typical command is:

MCHTOL/CONOUR, toler, RAPID:

-  The CONTUR, toler couplet defines the request for cutting motions
   analysis.

-  The RAPID keyword is asking for HF and RAPID motions to be analyzed.

-  The following commands and macro have been created to select the
   coordinate type to display in the listing file columns:

-  LPRINT / COORD, cs [,ABSOL|INCR]

-  LPRINT / COORD,OFF

where cs = 0: Joint frame, 1: Machine frame, 2: WCS

$COLCRD : 0: Joint frame, 1: Machine frame, 2: WCS

$COLINCR : 0: Absolute, 1: Incremental

Virtual Machine
~~~~~~~~~~~~~~~

-  | The Time line now have a vertical scrollbar when the height is too
     small
   | |image6|

-  | A new simulation statistic dialog is available and provide
     information about objects used in the simulation. This can be used
     to find simulation speed bottleneck caused by complex object or to
     validate macro runtime behaviour by allowing the user to compare
     internal object type and ID to see if they match the one requested
     by macro.
   | The statistics dialog can be accessed by the simulation top menu.
   | |image7|

CeRun Run-Time
~~~~~~~~~~~~~~

-  The Control Emulator Output trace window and trace of actions in the
   listing have been enhanced to include changes in spindle, diameter
   compensation and fixture compensation. Delay information also now
   includes the count of revolutions if that was how the delay was
   specified.

Integration Tools
-----------------

-  Manufacturing Extractors and the CAM Integration utility have been
   updated to support the following CAM systems and releases:

-  3DEXPERIENCE 2015x–2023x

-  CATIA V5R21, V5-6R2012–2023

-  Creo1–9

-  FeatureCAM 2017–2022

-  Fusion 360

-  Mastercam 2017–2024, and for SolidWorks 2014–2019

-  NX12, NX1847–2306

-  PowerMill 2017–2023

-  A new 3DEXPERIENCE extractor has been developed to support 2022x and
   later version. The new extractor is easier to use and do not require
   to pre-select the PPR in 3DEXPERIENCE. It also output more detailed
   information about the extraction process.

-  

Macro Functions and System Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  GENER Post-Processor:

-  A new $FEDRAP() function is available to get or set High Feed
   positioning threshold.

-  The Cycle Startup macro has a new $P21 variable that indicates the
   BORE-BACK bottom clearance plane value.

-  The following cycle variables have been added to support the new
   cycles:

-  $CYDIR (R/O) Cycle infeed rotation direction [0:?,1:CLW,2:CCLW]

-  $CYMULTRD (R/W) Rigid TAP cycle MULTRD value

-  $CYRATIO (R/W) TAP and REAM cycle RATIO value

-  $CYRIGID (R/W) Rigid tapping activation state [-1:?,0:off,1:on]

-  The $HSMODE system variable allow to set High Speed Machining mode to
   cutting (1), positioning (2) or all motion (3).

-  CERUN:

-  Added a multi-kernel synchronization method. The CERUN processing
   kernels can now synchronize their speed of processing based on the
   Virtual Machine channel cycle time. This feature is OFF by default
   and can be turned ON only in the super kernel “Machine Startup” macro
   by calling $FCETIMESYNC(). This is only available for merging lathe
   and composite CE.

-  The Cycle Event macro has a new $P6 variable that indicates the
   BORE-BACK bottom clearance plane value.

-  Added support for the following cycle variables: $CRMODE,
   $CYCLR{XYZ}, $CYCLRO, $CYDECR, $CYDIR, $CYDPTH, $CYFEDT, $CYFEDV,
   $CYINCR, $CYMCH, $CYORNT, $CYRATIO, $CYRETN, $CYRIGID and $CYTYPE.

-  Virtual Machine:

-  $FMSTOOL() can now be used to copy a tool. It will create a new tool
   as a copy of an existing one.

-  $FMSTOOL() now support generic mill tool.

PQRs
----

The following is a partial list of corrections made to V24.2.

CAM-POST
~~~~~~~~

+-------+--------------------------------------------------------------+
| PQR   | Description                                                  |
+=======+==============================================================+
| 0     | Deferred fixture compensation was not output before a canned |
| 06433 | cycle unless there was a positioning move prior to the       |
|       | cycle. [V24‑2328]                                            |
+-------+--------------------------------------------------------------+
| 0     | Added missing DWELL parameter for TAP, DEEP and BRKCHP       |
| 06432 | cycles in the Mastercam interface. [V24‑2327]                |
+-------+--------------------------------------------------------------+
| 0     | Gener $XJ, $YJ, $ZJ position are different from VMHUD XYZ.   |
| 06419 | Fixture compensation calculations were incorrect when        |
|       | Q360.00 was set to RTCP and RTCP was active. [V23‑2324,      |
|       | V24‑2324]                                                    |
+-------+--------------------------------------------------------------+
| 0     | The cycle depth register incremental output was always being |
| 06417 | computed from the R plane, even if "Normal" was requested    |
|       | (which computes the incremental value from the current       |
|       | position when the cycle is called). Post-processors that are |
|       | updated to V24.2 automatically change the response from      |
|       | "Normal" to "R" so that cycle output is not                  |
|       | changed. [V23‑2323, V24‑2323]                                |
+-------+--------------------------------------------------------------+
| 0     | Fixed issue with variable window truncating variable names   |
| 06416 | instead of calculating new column width.  [V23‑2322,         |
|       | V24-2322]                                                    |
+-------+--------------------------------------------------------------+
| 0     | Using sequence system variables in the parameter list of a   |
| 06404 | $FLOOK function call could result in a fatal error.          |
|       |  [V23‑2319, V24-2319]                                        |
+-------+--------------------------------------------------------------+
| 0     | The length value given with the LOADT/LENGTH command was not |
| 06394 | showing the offset value when the cursor is inside the       |
|       | "Tool" component in the kinematics window. [V23‑2316,        |
|       | V24-2316]                                                    |
+-------+--------------------------------------------------------------+
| 0     | When IJK and R circular data definition methods are allowed  |
| 06348 | and C2P mode is active the C2P preference for Center or      |
|       | Radius method was not being applied.  [V23‑2308, V24-2308]   |
+-------+--------------------------------------------------------------+
| 0     | SmartCUT and SmartPATH outputs G3 motion instead of G2.      |
| 06304 |                                                              |
|       | G2 motion was split by SmartCUT into High Feed (HF) segment  |
|       | followed by cutting feed segment. SmartPATH replaced HF G2   |
|       | segment to G1 linear motion. under some conditions the       |
|       | following G2 segment may be output as G3. [V23‑2251,         |
|       | V24-2251]                                                    |
+-------+--------------------------------------------------------------+
| 0     | The Cycle Startup Macro "SIEMENS drilling cycles" RMD action |
| 06311 | now uses the "DP" absolute cycle depth instead of "DPR"      |
|       | incremental depth when the DPR value is zero. A zero DPR     |
|       | would cause an alarm at the machine. [V23‑2250, V24-2250]    |
+-------+--------------------------------------------------------------+
| 0     | Z-axis over-travels while LIMT/POLAR, BAXIS is active.       |
| 06295 |                                                              |
|       | Under some conditions LIMIT/POLAR optimization may fail to   |
|       | adjust singular rotary axis position, to avoid over-travel   |
|       | motion of a linear axis. [V23‑2248, V24-2248]                |
+-------+--------------------------------------------------------------+

Control Emulator
~~~~~~~~~~~~~~~~

+-------+--------------------------------------------------------------+
| PQR   | Description                                                  |
+=======+==============================================================+
| 0     | LCS deactivation using $LCS was not working as expected.     |
| 06397 | $LCS was staying true. [V23‑2317, V24-2317]                  |
+-------+--------------------------------------------------------------+
| 0     | $FUNWIND() macro function used to unwind rotary axes was not |
| 06379 | working with 3DEXPERIENCE simulation. [V23‑2313, V24-2313]   |
+-------+--------------------------------------------------------------+
| 0     | The question 6.70 “Update WCS position from VM simulation"   |
| 06271 | from General Information in Quest was not working with the   |
|       | 3DEXPERIENCE simulation. [V23.0‑2244, V24-2244]              |
+-------+--------------------------------------------------------------+
|       |                                                              |
+-------+--------------------------------------------------------------+

Virtual Machine
~~~~~~~~~~~~~~~

+-------+--------------------------------------------------------------+
| PQR   | Description                                                  |
+=======+==============================================================+
| 0     | Fixe an issue where VM VSW and M3D configuration file would  |
| 06412 | not load or save properly if the file name or path contains  |
|       | non-ASCII character. [V23‑2322, V24-2322]                    |
+-------+--------------------------------------------------------------+
| 0     | Timeline was not showing material removal rate graphic       |
| 06365 | properly. [V23‑2311, V24-2311]                               |
+-------+--------------------------------------------------------------+
| 0     | Fix very slow timeline manipulation across tool change on    |
| 06274 | tool having complex holder. [V23‑2244, V24-2244]             |
+-------+--------------------------------------------------------------+

Macro Processor
~~~~~~~~~~~~~~~

+-------+--------------------------------------------------------------+
| PQR   | Description                                                  |
+=======+==============================================================+
| 0     | Fixed an issue with $FMRU_GETPARAM not returning the         |
| 06373 | provided default value if the key does not exist in the MRU  |
|       | file.  [V23‑2311, V24-2311]                                  |
+-------+--------------------------------------------------------------+
|       |                                                              |
+-------+--------------------------------------------------------------+
|       |                                                              |
+-------+--------------------------------------------------------------+
|       |                                                              |
+-------+--------------------------------------------------------------+

.. |image1| image:: ./media/image1.png
   :height: 270px
.. |image2| image:: ./media/image2.png
   :height: 180px
.. |image3| image:: ./media/image3.png
   :height: 330px
.. |image4| image:: ./media/image4.png
   :height: 360px
.. |image5| image:: ./media/image5.png
   :height: 390px
.. |image6| image:: ./media/image6.png
   :width: 4.88627in
   :height: 1.26594in
.. |image7| image:: ./media/image7.png
   :width: 5.01754in
   :height: 1.43343in
