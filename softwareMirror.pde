import processing.video.*;

float BWthreshold;
float Cthreshold;

int mode;

//VIDEO
Capture video;

//STATIC IMAGE
PImage newImage;

void setup()
{
  size(640, 480);
  video = new Capture(this, 640, 480);
  video.start();
  
  newImage = new PImage(video.width, video.height);
  
  //0 - b/w
  //1 - b/w + RED
  //2 - b/w + GREEN
  //3 - b/w + BLUE
  mode = 0;
}

void draw()
{
  if(video.available()) video.read();
  
  video.loadPixels();
  newImage.loadPixels();
  
  BWthreshold = map(mouseX, 0, width, 0, 255);
  Cthreshold = map(mouseY, 0, height, 0, 255);
  
  //Loop over the entire image
  for(int x = 0; x < video.width; x++)
  {
    for(int y = 0; y < video.height; y++)
    {
      int location = x + y*video.width;
      color pixel = video.pixels[location];
      
      //Black/white check
      if(brightness(pixel) > BWthreshold)
      {
        newImage.pixels[location] = color(255);
      }
      else
      {
        newImage.pixels[location] = color(0);
      }
      
      //Looking for RED
      if(mode == 1)
      {
        if(red(pixel) > Cthreshold && red(pixel) > (green(pixel) * 3) && red(pixel) > (blue(pixel) * 3))
        {
          newImage.pixels[location] = color(255, 0, 0);
        }
      }
      //Looking for GREEN
      else if(mode == 2)
      {
        if(green(pixel) > Cthreshold && green(pixel) > (red(pixel) * 1.25) && green(pixel) > (blue(pixel) * 1.25))
        {
          newImage.pixels[location] = color(0, 255, 0);
        } 
      }
      //Looking for BLUE
      else if(mode == 3)
      {
        if(blue(pixel) > (Cthreshold * .70) && blue(pixel) > (green(pixel) * 2) && blue(pixel) > (red(pixel) * 2))
        {
          newImage.pixels[location] = color(0, 0, 255);
        } 
      }
      
    }
  }
  
  newImage.updatePixels();
  
  image(newImage, 0, 0);
}

//Respond to key presses
void keyPressed()
{
  //space to change mode
  if(key == ' ')
  {
    mode++;
    if(mode > 3) mode = 0;
  }
  
  //p to print
  if(key == 'p')
  {
    save("pic.png");
  }
}
