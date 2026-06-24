#define INPUT_REG (*(volatile unsigned int*)0x10000000)
#define LED_REG   (*(volatile unsigned int*)0x10000004)
#define SEG_REG   (*(volatile unsigned int*)0x10000008)

#define PASSWORD 10   // 你撥 0101 時，板子實際讀到 A = 10

int main()
{
    int fail_count = 0;
    int locked = 0;

    while (1)
    {
        unsigned int data = INPUT_REG;

        int input   = data & 0x0F;
        int confirm = (data >> 4) & 1;
        int unlock  = (data >> 6) & 1;

        if (locked)
        {
            LED_REG = 4;
            SEG_REG = 12; // L

            if (unlock)
            {
                locked = 0;
                fail_count = 0;
                LED_REG = 8;
                SEG_REG = 10; // A
            }
        }
        else
        {
            if (confirm)
            {
                if (input == PASSWORD)
                {
                    fail_count = 0;
                    LED_REG = 1;
                    SEG_REG = 1; // 正確
                }
                else
                {
                    fail_count++;
                    LED_REG = 2;
                    SEG_REG = 14; // E

                    if (fail_count >= 3)
                    {
                        locked = 1;
                        LED_REG = 4;
                        SEG_REG = 12; // L
                    }
                }

                while (((INPUT_REG >> 4) & 1) == 1);
            }
        }
    }

    return 0;
}