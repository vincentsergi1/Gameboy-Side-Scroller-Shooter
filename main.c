#include <gb/gb.h>
#include <stdio.h>
#include <stdint.h>

//Created with GBTD, exported to .c with options from: 0, to: 0, label: smile
const unsigned char fireball[] =
{
  0x00,0x00,0x08,0x1E,0x1E,0x07,0x2B,0x0D,
  0x2D,0x0B,0x1E,0x07,0x08,0x1E,0x00,0x00
};
const unsigned char player[] =
{
  0x00,0x18,0x18,0x00,0x00,0x18,0x0F,0x17,
  0x0C,0x14,0x00,0x18,0x18,0x00,0x18,0x18
};

void main(){
	
	NR52_REG = 0x80; //turn on the sound
    NR50_REG = 0x77; // Sets volume level to the max (0x77) for both Left and Right
	NR51_REG = 0xFF; // select all sound channels, one bit for left, one bit for right


	uint8_t joydata;
	uint8_t x = 55; // Our beginning x coord
	uint8_t y = 76; // Our beginning y coord
	uint8_t z = 55;
	uint8_t i = 55;
	uint8_t w = 75;
	uint8_t fired = 0;
	
	SPRITES_8x8;
	set_sprite_data(1, 1, fireball);
    set_sprite_tile(1, 1);
	//set_sprite_data(0, 1, fireball);
	//set_sprite_tile(0, 0);
	//move_sprite(1, 95, 75);
	//set_sprite_tile(1, 2);
	//move_sprite(1, 55 + 8, 75);
		
	set_sprite_data(0, 1, player);
	set_sprite_tile(0, 0);
	move_sprite(0, x, y);
	//set_sprite_tile(3, 10);
	//move_sprite(3, 95 + 8, 75);


   SHOW_SPRITES;

	while(1){
		joydata = joypad(); // Read once per frame and cache the result

		// if (joydata & J_RIGHT) // If RIGHT is pressed
		// {
		// 	x = x + 2;
		// 	move_sprite(0,x,y); // move sprite 0 to x and y coords
		// }
		
		// if (joydata & J_LEFT)  // If LEFT is pressed
		// {
		// 	x = x - 2;
		// 	move_sprite(0,x,y); // move sprite 0 to x and y coords
		// }
		
		if (joydata & J_UP)  // If UP is pressed
		{ 
			if (y == 18){

			}else
			if (y > 18)
			{
			y = y - 2;
			move_sprite(0,x,y); // move sprite 0 to x and y coords
		}
		}
		
		if (joydata & J_DOWN)  // If DOWN is pressed
		{
			if (y == 150){

			}else
			if ( y < 150)
			{
			y = y + 2;
			move_sprite(0,x,y); // move sprite 0 to x and y coords
		}
		}

      if (joydata & J_B && z == x)  // If gun has not been fired and B is pressed, then draw bullet
		{
			//execute gunshot sound first

		  // see https://github.com/bwhitman/pushpin/blob/master/src/gbsound.txt
            // chanel 1 register 0, Frequency sweep settings
            // 7	Unused
            // 6-4	Sweep time(update rate) (if 0, sweeping is off)
            // 3	Sweep Direction (1: decrease, 0: increase)
            // 2-0	Sweep RtShift amount (if 0, sweeping is off)
            // 0001 0110 is 0x16, sweet time 1, sweep direction increase, shift ammount per step 110 (6 decimal)
            NR10_REG = 0x1F; 

            // chanel 1 register 1: Wave pattern duty and sound length
            // Channels 1 2 and 4
            // 7-6	Wave pattern duty cycle 0-3 (12.5%, 25%, 50%, 75%), duty cycle is how long a quadrangular  wave is "on" vs "of" so 50% (2) is both equal.
            // 5-0 sound length (higher the number shorter the sound)
            // 01000000 is 0x40, duty cycle 1 (25%), wave length 0 (long)
            NR11_REG = 0x10;

            // chanel 1 register 2: Volume Envelope (Makes the volume get louder or quieter each "tick")
            // On Channels 1 2 and 4
            // 7-4	(Initial) Channel Volume
            // 3	Volume sweep direction (0: down; 1: up)
            // 2-0	Length of each step in sweep (if 0, sweeping is off)
            // NOTE: each step is n/64 seconds long, where n is 1-7	
            // 0111 0011 is 0x73, volume 7, sweep down, step length 3
            NR12_REG = 0xF7;  

            // chanel 1 register 3: Frequency LSbs (Least Significant bits) and noise options
            // for Channels 1 2 and 3
            // 7-0	8 Least Significant bits of frequency (3 Most Significant Bits are set in register 4)
            NR13_REG = 0x00;   

            // chanel 1 register 4: Playback and frequency MSbs
            // Channels 1 2 3 and 4
            // 7	Initialize (trigger channel start, AKA channel INIT) (Write only)
            // 6	Consecutive select/length counter enable (Read/Write). When "0", regardless of the length of data on the NR11 register, sound can be produced consecutively.  When "1", sound is generated during the time period set by the length data contained in register NR11.  After the sound is ouput, the Sound 1 ON flag, at bit 0 of register NR52 is reset.
            // 5-3	Unused
            // 2-0	3 Most Significant bits of frequency
            // 1100 0011 is 0xC3, initialize, no consecutive, frequency = MSB + LSB = 011 0000 0000 = 0x300
            NR14_REG = 0xF7;

		  z = z + 5;
		  w = y;
		  if (z < 170){
			move_sprite(1,z,w);
		  }
		}

      if (z > x && z < 170)  // If gun has been fired and is within the screen limit
		{
		  z = z + 5;
		  move_sprite(1,z,w);	  
		  if (z == 170){
			z=x;
		  }
		}
		wait_vbl_done();
      }
} 