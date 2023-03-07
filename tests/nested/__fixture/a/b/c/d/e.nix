{ self, super }:

{
  value = "${super.value}.e";
  f.value = "${self.value}.f";
}
