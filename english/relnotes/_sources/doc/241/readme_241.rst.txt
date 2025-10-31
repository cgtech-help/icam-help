ICAM V24.1 Release
******************

These release notes describe the most significant V24.1 enhancements and
problem corrections.

Some of the enhancements and many of the problem corrections are also
available in updated releases of V23. If so, the release build number is
listed at the end of the enhancement or problem description in
[V\ *vv*-*yyww*] format, where *vv* is the version, *yy* is the year and
*ww* is the week (1-52).

We hope you enjoy your new release of the ICAM products and we sincerely
welcome your feedback.

*The CGTech ICAM R&D Team
October 1, 2022*

Systems and Packaging
---------------------

Product Availability
~~~~~~~~~~~~~~~~~~~~

+--------------------------+-------------------------------------------+
| System Manufacturer      | O/S Minimum Requirement                   |
+--------------------------+-------------------------------------------+
| Microsoft Windows        | 8.1, 10, 11                               |
| 32-bit*\*                |                                           |
+--------------------------+-------------------------------------------+
| Microsoft Windows 64-bit | 8.1, 10, 11, 2012, 2012R2, 2016, 2019,    |
|                          | 2022                                      |
+--------------------------+-------------------------------------------+

ICAM software is not available for UNIX systems. An ICAM database
created with V20 or earlier on a UNIX system is fully compatible with
ICAM software running on Windows systems.

ICAM V24.1 can run under Microsoft Windows 7 and 8, and Microsoft
Windows Server 2008R2, but these operating systems are no longer
supported by Microsoft.

\*\* V24.x are the final versions supporting 32-bit architectures. The
32-bit installers are available with V24.x on demand only. Contact
support@icam.com should you require a 32-bit installation. Note that
there is no performance benefit to using 32-bit, but there is a
disadvantage with 32-bit of having less available memory for a running
process.

Productivity Tools
------------------

ICAM P\ ortal
~~~~~~~~~~~~~

-  The ICAM portal application has the following quality of life
   enhancements:

-  All of the applications and utilities accessible from the portal can
   now be run elevated by right-clicking on the application or utility
   and selecting “\ *Run as Administrator*\ ”.

|image1|

-  The portal tray icon menu now shows the application icons to the left
   of the application names so as to more easily identify them.

A new “\ *Documentation”* menu item has also been added. It will open
the ICAM installation documentation sub-directory in Windows Explorer.

|image2|

Quest D\ eveloper’s
~~~~~~~~~~~~~~~~~~~

-  The questionnaire has been enhanced with new and modified questions,
   as follows.

-  The *Control Description / Tool and Fixture Compensation* section has
   been expanded to add questions allowing for extended fixture
   compensation codes to be defined. Codes and registers can be easily
   defined to support, for example, the Siemens G501-G599 range of G
   codes and the FANUC G54.1 P1-P49 range of P offsets.

-  A new *Code Table* section has been added to the bottom of
   post-processor navigator, below all chapters. This section provides a
   summary of all codes and registers defined in the questionnaire.

|image3|

This section is updated automatically when opening it. The main listed
items are the codes as defined in the code questions throughout the
questionnaire. Codes that have associated registers can be expanded to
see the list of registers as defined in the questionnaire.

|image4|

This section is read-only; codes and registers cannot be changed
directly in the table itself. However, changes to registers and codes
can easily be done by double-clicking on a code or register in the
table, which will open the appropriate Questionnaire section and set the
focus on the question that defined the selected item.

-  The QUEST database navigator and database view will now show a
   preview of the selected Virtual Machine model. The model must have
   been generated using the new V24.1 release for the preview screenshot
   to be available.

|image5|

-  When developing a Virtual Machine model, all popular image formats
   (e.g., png, jpeg…) can now be used when adding images to the model.
   This enhancement eliminates the bmp-only and size restrictions from
   earlier versions.

Gener Post-processing
~~~~~~~~~~~~~~~~~~~~~

-  A new Kinematic status window is available on the Gener user
   interface. This window displays the current status of all components
   of the machine kinematics and transformations that may affect the
   computation of coordinates generated in the output NC program.

|image6|

A right-mouse context menu provides the following choices:

-  Show limits: This option displays the types of transformations
   applied to the coordinates used to compare against the travel limits
   of the machine. The series of transformation are displayed along the
   top.

-  Show coordinate variables: This option displays information about
   different coordinates that are computed during the process. The
   location of the variable is giving a hint about which kinematics
   components are currently affecting the coordinate calculation. The
   following coordinate systems are available:

-  $XC,$YC,$ZC: CL file coordinate system

-  $XW,$YW,$ZW: Local coordinate system (i.e. workpiece coordinate
   system)

-  $XM,$YM,$ZM: Machine coordinate system

-  $XJ,$YJ,$ZJ: Joint coordinates used for limit checking

-  Show inactive status: This option shows kinematics components that
   are currently not being used, but that can be available to modify
   coordinate calculations.

Virtual Machine
~~~~~~~~~~~~~~~

-  The launch panel now shows a preview of the model selected for the
   job. The model must have been generated using V24.1 for the preview
   to be shown.

|image7|

-  The HUD is now multi-language enabled. Information in the HUD will be
   shown in the current selected language.

|image8|

-  The right-mouse context window in the run-time Simulation window now
   provides a *Properties* selection that can be used to view
   information about the selected component. Run-time components, such
   as parts, fixtures and tools, can be modified from the Properties
   dialog.

|image9|

-  The Time Line window horizontal scroll bar now shows a miniature of
   the entire process, with the portion currently visible in the Time
   Line view highlighted. We call this the “Time Line Miniature” or TLM
   for short. The TLM box can be dragged and manipulated in the same way
   as any horizontal scrollbar thumb control. In addition, holding the
   SHIFT key before left clicking and then dragging in the TLM (i.e.,
   selecting a region in the horizontal bar) will set the main Time Line
   view to the selected time range.

|image10|

The TLM shows key information from the main Time Line whether selected
for display or not. This includes object collisions, MRS collisions,
over travels and tool changes.

The TLM also features an easy access toolbar at the bottom-left,
providing quick access to the following existing features of the Time
Line:

-  *Undo/Redo* undo or reapply Time Line zoom and pan changes

-  *Fit* to zoom out the Time Line to view the entire process

-  *Find previous/next* to search for the next occurrence of selected
   search target

-  The Time Line now uses the mouse cursor as the focus point when
   zooming in and out. This makes zooming easier without having to
   adjust the scrollbar.

-  The Simulation window tool-path trace minimum length of 1 second has
   been reduced to allow a minimum of 1/100 of a second. This can be
   useful when analyzing tool-paths where the tool is moving very fast.

-  The Tool Dialog bottom right preview pane now has a |image11| control
   that when selected will spin the tool (i.e., start the spindle). This
   only has a visible effect for Generic solid tools that are not
   already surfaces of revolution.

-  Ongoing performance improvements.

-  Various improvements have been done to shorten the loading and
   restart times of jobs.

-  Simulation processing time has been reduced due to better usage of
   multi-core CPU during collision detection.

Gener & CeRun Run-Time
~~~~~~~~~~~~~~~~~~~~~~

-  For users of dedicated post-processors or dedicated control
   emulators, the run-time user interface now allows the variable window
   to be used to watch variables.

This can be used to help ICAM support or dealers during the development
and training for the customer. The variables that are documented as
writable can be modified for testing purposes.

|image12|

Integration Tools
-----------------

-  The CAM Integration Utility has been redesigned to eliminate the use
   of tabs, to be more responsive, and also to be easier to use. The
   *Options* button at the bottom can be used to control the list of CAM
   systems and ICAM versions shown in the upper left window (currently
   installed software is shown by default).

|image13|

-  *Export* and *Import* buttons simplify the distribution of CAM
   integration settings between users.

-  It is now possible to define multiple databases that can be used with
   a particular CAM system / ICAM version combination.

-  |image14|\ The CAM extractor UI tolerance settings have been
   modified:

-  Tolerances are now saved globally instead of being associated with
   the current VM model.

-  As many sets of tolerances as required can be defined.

-  Sets of tolerances can be given user-defined names.

-  Manufacturing Extractors and the CAM Integration utility have been
   updated to support the following CAM systems and releases:

-  3DEXPERIENCE 2015x–2022x

-  CATIA V5R21, V5-6R2012–2022

-  Creo1–8

-  FeatureCAM 2017–2022

-  Fusion 360

-  Mastercam 2017–2023, and for SolidWorks 2014–2019

-  NX8–12, NX1847–2206

-  PowerMill 2017–2021

-  A new CAM interface kit is available for GibbsCAM milling.

-  The Manufacturing Extractors are continuously updated, which is why
   ICAM provides an Integration Tools installer separate from the
   Productivity Tools (i.e., main products) installer. There are far too
   many minor enhancements to list here, but the following are some more
   significant enhancements that may be of interest:

-  Added support for NX multi-edge tool with tracking points.

-  The Extractor UI is shown faster than before and diagnoses more
   events.

-  More flexibility has been added for presetting multi-setup. This
   includes better control over tool axis, stock axis, and program
   assignment.

Macros and Customization
------------------------

Macro Functions
~~~~~~~~~~~~~~~

-  General functions:

-  A new **$FVROTV(angle,v1,v2)** function is available to compute a
   vector rotated around an axis. This function returns a vector
   resulting from the *angle* degrees CCLW rotation of vector *v1* about
   an axis defined by vector *v2*. Vector *v2* defining the rotation
   axis must have non-zero length. The CCLW rotation direction is
   defined by the orientation of the *v2* vector.

-  Virtual Machine functions:

-  Changed the default channel for **$FMSPRID** and **$FMSPROB.** Those
   functions were previously always using channel 1. They will now use
   the current active channel as defined by the **$VMCHN** variable. It
   is possible to specify a different channel as an argument.

PQRs
----

The following is a partial list of corrections made to V24.1.

CAM-POST
~~~~~~~~

+-------+--------------------------------------------------------------+
| PQR   | Description                                                  |
+=======+==============================================================+
| 0     | Provide an option allowing to output DPM F velocity for      |
| 06208 | rotary-only motions, while RTCP is active. [V24‑2236]        |
+-------+--------------------------------------------------------------+
| 0     | HyperMILL interface did not support CCLW spindle output for  |
| 06243 | milling. [V24‑2236]                                          |
+-------+--------------------------------------------------------------+
| 0     | Fixed issue where source window breakpoints would not show   |
| 06244 | on startup. [V23‑2236, V24‑2236]                             |
+-------+--------------------------------------------------------------+
| 0     | When post-processing from CATIA/3DEXPERIENCE, if the OS RPC  |
| 06242 | server is overloaded, Gener will not complain about the RPC  |
|       | server being. It will just bypass it and re-update on the    |
|       | next pass. [V23‑2236, V24‑2236]                              |
+-------+--------------------------------------------------------------+
| 0     | Fixed an issue where the process would remain in memory      |
| 06232 | after exit when exit and having variables in the watch       |
|       | window.  [V23‑2234, V24-2234]                                |
+-------+--------------------------------------------------------------+
| 0     | SAFETY/NEXT,...,LENGTH description and functionality do not  |
| 06228 | match.                                                       |
|       |                                                              |
|       | Supported syntax of the command and its description has been |
|       | adjusted to be compatible with that of CUTCOM command.       |
|       |  [V24‑2233]                                                  |
+-------+--------------------------------------------------------------+
| 0     | Fix issue where opening a new PP, CE or model in QUEST would |
| 06227 | use another opened comment section content for the new       |
|       | one. [V23‑2233, V24-2233]                                    |
+-------+--------------------------------------------------------------+
| 0     | LINTOL interpolation was occasionally failing when the tool  |
| 06214 | axis vector remains the same at the start and end of the     |
|       | motion.  [V23‑2230, V24-2230]                                |
+-------+--------------------------------------------------------------+
| 0     | Nested $FLOOK calls could in some instances result in the    |
| 06198 | look-ahead not being executed when it is later called in a   |
|       | non-nested state. [V23‑2227, V24-2227]                       |
+-------+--------------------------------------------------------------+
| 0     | LIMIT/ROTREF and SAFETY/XYPLAN do not work together. When    |
| 06189 | position is singular SAFETY/XYPLAN was removing LIMIT/ROTREF |
|       | computed rotary position. [V23‑2224, V24-2224]               |
+-------+--------------------------------------------------------------+
| 0     | The $FTLTAB function would not list tools loaded in a head   |
| 06180 | other than the one that was active when the function was     |
|       | called. [V23‑2223, V24-2223]                                 |
+-------+--------------------------------------------------------------+
| 0     | Improve sorting speed of the diagnostic window when the      |
| 06154 | number of message is getting large. [V23‑2218, V24-2218]     |
+-------+--------------------------------------------------------------+
|       |                                                              |
+-------+--------------------------------------------------------------+

Control Emulator
~~~~~~~~~~~~~~~~

+-------+--------------------------------------------------------------+
| PQR   | Description                                                  |
+=======+==============================================================+
| 0     | Fixed an issue for PSE job where the CE subprogram startup   |
| 06239 | macro could not resolve the subprogram location after Gener  |
|       | would generate it. [V23‑2235, V24-2235]                      |
+-------+--------------------------------------------------------------+
| 0     | Fixed Heidenhain repeat label syntax support in              |
| 06203 | CERUN. [V23‑2229, V24-2229]                                  |
+-------+--------------------------------------------------------------+
| 0     | Fixed a crash that would occur when a new tool is created    |
| 06143 | and no previous tool was assigned to the tool                |
|       | axis. [V23.0‑2116, V24-2216]                                 |
+-------+--------------------------------------------------------------+
|       |                                                              |
+-------+--------------------------------------------------------------+

Virtual Machine
~~~~~~~~~~~~~~~

+-------+--------------------------------------------------------------+
| PQR   | Description                                                  |
+=======+==============================================================+
| 0     | Fix a problem where collision are not properly detected in   |
| 06213 | continuous playback mode. [V23‑2230, V24-2230]               |
+-------+--------------------------------------------------------------+
| 0     | Fixed issue where the simulation camera would be too         |
| 06149 | slow. [V23‑2217, V24-2217]                                   |
+-------+--------------------------------------------------------------+
|       |                                                              |
+-------+--------------------------------------------------------------+

Macro Processor
~~~~~~~~~~~~~~~

+-------+--------------------------------------------------------------+
| PQR   | Description                                                  |
+=======+==============================================================+
| 0     | Fixed a problem where returning the result of a function     |
| 06085 | macro in an array or sequence element would make the         |
|       | function macro be called in a loop.  [V23‑2209, V24-2209]    |
+-------+--------------------------------------------------------------+
| 0     | Improve OPEN command on the macro compiler to support using  |
| 06083 | a function or variable to specify the FRONT or REAR          |
|       | argument. [V23‑2209, V24-2209]                               |
+-------+--------------------------------------------------------------+
|       |                                                              |
+-------+--------------------------------------------------------------+

Licensing
~~~~~~~~~

+-------+--------------------------------------------------------------+
| PQR   | Description                                                  |
+=======+==============================================================+
| 0     | Fixed a vulnerability in the license server where a          |
| 06168 | non-admin account could change the service configuration.    |
|       | [V23-2209, V24-2209]                                         |
+-------+--------------------------------------------------------------+
| 0     | Fixed an issue where the client software could not connect   |
| 06086 | to the license server if the active windows profile user     |
|       | name has spaces  [V23-2221, V24-2221]                        |
+-------+--------------------------------------------------------------+
|       |                                                              |
+-------+--------------------------------------------------------------+

.. |image1| image:: ./media/image1.png
   :width: 2.96316in
   :height: 1.06in
.. |image2| image:: ./media/image2.png
   :width: 1.29in
   :height: 2.03684in
.. |image3| image:: ./media/image3.png
   :width: 2.55in
   :height: 1.40992in
.. |image4| image:: ./media/image4.png
   :width: 5.39589in
   :height: 2.47in
.. |image5| image:: ./media/image5.png
   :width: 5.90836in
   :height: 4.1in
.. |image6| image:: ./media/image6.png
   :width: 5.92966in
   :height: 1.77937in
.. |image7| image:: ./media/image7.png
   :width: 4.10871in
   :height: 2.71in
.. |image8| image:: ./media/image8.png
   :width: 1.95in
   :height: 1.82812in
.. |image9| image:: ./media/image9.png
   :width: 1.6481in
   :height: 0.79in
.. |image10| image:: ./media/image10.png
   :width: 5.97966in
   :height: 1.94797in
.. |image11| image:: ./media/image11.png
   :width: 0.2in
   :height: 0.2in
.. |image12| image:: ./media/image12.png
   :width: 3.68455in
   :height: 1.93in
.. |image13| image:: ./media/image13.png
   :width: 4.07938in
   :height: 4.58in
.. |image14| image:: ./media/image14.png
   :width: 1.07986in
   :height: 2.17292in
