void codegen();
void codegen()
{
  int a = (2147483647 - 1) / 2147483646; // a = 1
  do
  {
    digitalWrite(27, 1);
    delay(a * 1000);
    digitalWrite(27, 0);
    delay((10 - a) * 1000);
  }
  while (++a <= 9);
}

