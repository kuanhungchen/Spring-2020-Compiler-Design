void codegen();
void codegen()
{
  int a = 4; // a = 4
  int b = (a - 2) * (a - 1); // b = 6
  digitalWrite(27, 1);
  delay(a * 1000); // delay 4 seconds
  digitalWrite(27, 0);
  delay(b * 1000); // delay 6 seconds
}
