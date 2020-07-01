void codegen();
void codegen()
{
  int a = 1 + 2 * 1; // a = 3
  int b = (a + 3) / 2; // b = 3
  if (a-- == 3)
  {
    digitalWrite(26, 1);
    delay(a * 2000); // delay 4 seconds
  }
  digitalWrite(26, 0);
  delay(b * 1000); // delay 3 seconds
}
