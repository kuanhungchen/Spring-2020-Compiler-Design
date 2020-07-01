void codegen();
void codegen()
{
  int a = ((1 + 2) * 7 - 1) / 2; // a = 10
  while (--a)
  {
    digitalWrite(26, 1);
    delay((10 - a + 1) * 1000);
    digitalWrite(26, 0);
    delay((a - 1) * 1000);
  }
}
