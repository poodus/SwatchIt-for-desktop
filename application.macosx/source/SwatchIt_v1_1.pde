/*

 SwatchIt: color swatch generating tool for Graphic Designers and Illustrators
 
 inspired by the CASA de MUSICA logo generator
 "In branding, sameness is overrated" - Stefan Seigmeister
 http://www.ted.com/talks/stefan_sagmeister_the_power_of_time_off.html
 
 @author Shane Reetz shanereetz@gmail.com
 @version 1.1
 @since 2012-11-7
 
 */
import processing.pdf.PGraphicsPDF;
String inputImage; // the file to be sampled
int ellipseRadius = 30; // how big to make the circles...
int xSamples = 4; // # of samples to take in the X direction
int ySamples = 4; // # of samples to take in the Y direction
int swatchDimension = 100;
color fillColor;
PImage img = new PImage();

void setup()
{
  inputImage = selectInput("Please select an image to sample");
  if (inputImage==null)
  {
    exit();
  }
  else
  {
    // if the image is too big, make it smaller...
    img = loadImage(inputImage);
    if (img.width > 1000)
    {
      img.resize(1000, int(img.height/(img.width/1000.0)));
    }
    size(img.width, img.height);
    background(img);
  }
  loadPixels();
  stroke(255, 0, 0);
  strokeWeight(1);
  smooth();
  noLoop();
}
/*
draw()
 
 Main loop for program
 
 */
void draw() 
{
  background(img);
  loadPixels();
  saveIt(sampleIt(xSamples, ySamples), swatchDimension, true);
}
/*

 sampleIt()
 
 @param int xDivisions, yDivisions
 
 */
color[] sampleIt(int xDivisions, int yDivisions)
{
  color[] samples = new color[xDivisions*yDivisions];
  xDivisions+=1;
  yDivisions+=1;
  int count = 0;
  for (int i = 1; i < yDivisions; i+=1) //height
  {
    for (int j = 1; j < xDivisions; j+=1) //width iterations
    {
      samples[count] = getAvgColor(pointToPixel(j*width/xDivisions, i*height/yDivisions));
      fill(samples[count]);
      ellipse(j*width/xDivisions, i*height/yDivisions, ellipseRadius, ellipseRadius);
      noStroke();
      rect(0, count*img.height/((yDivisions-1)*(xDivisions-1)), 50, (count+1)*img.height/(yDivisions-1)*(xDivisions-1));
      stroke(255, 0, 0);
      count++;
    }
  }
  return samples;
}

/*

 pointToPixel()
 
 Converts an (x, y) coordinate to a number cooresponding
 with an elment in the pixels array
 
 @param int x, y
 
 */

int pointToPixel(int x, int y)
{
  return x+y*(width);
}
/*

 getAvgColor()
 
 Returns an average color.
 
 @param int pixel
 
 */
color getAvgColor(int pixel)
{
  return pixels[pixel];
}
/*

 saveIt()
 
 A derivative of save(). This method will take
 the colors found by the color finder, and export
 a swatch image of them. Woot!
 
 @param color[] samples, boolean sortMe, @swatchDimension
 
 */
void saveIt(color[] samples, int swatchDimension, boolean sortMe)
{
  String[] splitit = split(inputImage, '\\');
  inputImage = splitit[splitit.length-1];
  println(splitit.length-1);
  String filename = year()+ "_" + month() + "_" + day() + hour()+ "_" + minute() + "_swatch_for_"+ inputImage + "_" + ".pdf";
  // Sort colors
  if (sortMe)
  {
    samples = sort(samples);
  }
  PGraphics pg = createGraphics(samples.length*swatchDimension, swatchDimension, PDF, filename);
  pg.beginDraw();
  for (int i = 0; i < samples.length; i++)
  {
    pg.noStroke();
    pg.fill(samples[i]);
    pg.rect(i*swatchDimension, 0, i+1*swatchDimension, swatchDimension);
  }
  pg.endDraw();
  pg.dispose();
}

