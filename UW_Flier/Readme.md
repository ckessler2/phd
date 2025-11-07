Alsomitra flier manufacturing & testing info

Open NRF Connect
Launch quick start app, then under develop, launch VS Code (can't just launch from desktop)
Or (maybe) open VScode, click NRF on left bar, then dots next to project, start new terminal. 
Check if west command is recognised

Build and flash program:

cd ~/ncs/v3.1.0/zephyr/samples/basic/blinky
rm -rf build
west build -b nrf52840dk/nrf52840 --pristine

west flash

west build -b nrf52840dk/nrf52840 --pristine
west flash --dev-id 683604832

nrfjprog --snr 683604832 --readregs

west flash --dev-id 683604832


FLIER BASE STRUCTURE (Mylar, rod, glue, pins, 3D printer)

Laser cut outline with 3.6mm Mylar
Put outline, pins, and washers into printed jig
Place rod onto jig, glue and let set

Mylar - https://www.chemplex.com/150-spectrocertifiedr-thin-film-sample-support-windows-in-continuous-rolls-pre-perforated-rolls-and-precut-circles.html
Rod - https://micronwings.com/product/carbon-fibre-rod-0-25mm/
Glue - https://bsi-inc.com/hardware/hardware.html

FLIER ACTUATOR (Kapton, magnets, wire, glue, allen key, winder, microscope)

Make tube from kapton and glue (using allen key)
Using winder and glue, coil wire onto tube (30 turns 3 times for 90 coils)
Solder wires onto connectors

ELECTRONICS BOARD

Laser cut board, remove copper strips, polish contacts
Add solder balls (in fridge, put back when done) to correct contacts
Place components on solder
Turn on heat plate until solder melts


