void codegen();
void codegen()
{
  int a = (2147483647 - 1) / 2147483646 - 1; // a = 0
  if (a++)
  {
    digitalWrite(27, 1);
    delay(a * 1000); // no execute
  }
  else
  {
    digitalWrite(27, 1);
    delay((a + 1) * 3000); // delay 6 seconds
  }
  digitalWrite(27, 0);
  delay(2000); // delay 2 seconds
}
