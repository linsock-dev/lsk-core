<?php
// Include the main TCPDF library (search for installation path).
require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

// Extend the TCPDF class to create custom Header and Footer
if (!class_exists('MYPDF')) {
    class MYPDF extends TCPDF
    {

        public function Header()
        {
            // Logo 
            $this->Image(
                '@' . base64_decode('iVBORw0KGgoAAAANSUhEUgAAAXkAAAB1CAYAAACrtpHyAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAFxEAABcRAcom8z8AAE9aSURBVHhe7Z0HYBTF98cntNA7hF5CCAQIvffeewelSFVpooKINBXpIOWvIAKiICAoRQSB0HtvCYSQEEpIQiAhQEILZf77fTt7ubJ3uZC7BH7OB8fdnZ0tt7t5M/PmzXsuXIE5iYMHD7JmzZqxuLg4kSNJiOLuxZmfrx/LmDGjyJFIJJI3J5VYOoULvhekgE8k9erUkwJeIpE4DKcKeb+LfmJNYi+VKlcSaxKJRJJ0nCbkX7x4wU6dPiW2JPbi4eEh1iQSiSTpOE3I3717lwUFBYktiT3kyp2LlfMuJ7YkEokk6ThNyJ87d47FxsSKLYk9lPQoyYoVLSa2JBKJJOk4TcifPXeWOdFw53+S8uXLizWJRCJxDE4zoezVqxdbt26d2JLYw+Ili9mHQz8UW0njRdwL9vjxY+UNM6dVtjhv+vTpnWoNhGs8jn3M4l7GKT9F+TECrvzDf2nTpmVZsmQRuRKJxBynCPnY2FhWu3Zt5uvrK3JSjkyZMpGgePLkich5O0mTJg07cOAAPTdHMGnSJLZurVLJOlnIT5g4gfXv11/kOJ6wsDDWrm079ijmkcgxpWnTpmzx4sViSyKRWAAh72guX77MU6dODcmS4qlnr568Ro0auvvepuRewp3fvXtXPMEk8przJo2b6F7H0WnXrl3ios5h3/59utfV0ogRI0RJiUSih1N08ufPn2evXr0SWylLjpw5WOpUqcXW20vRokVZnjx5xFbSiIyMZLdCbokt55EpcyZWrLhzB4ovnL8g1vSpXcsxPR+J5H8Vpwj5M2fPiLWUJ0vmLCxjprd/BmmFChXEWtK5E3EnWYQ8rIHy58svtpzD+QvnxZo+Hp5yXoFEYgunCPm3aaYrWsgYHHzbqVWjllhLOkHXgtjzZ8/FlvNAKz5z5sxiy/G8fPmSBQYGii1LChUqxAoWLCi2JBKJHg4X8uHh4SwgIEBspTzZsmVj+fLlE1tmxBtrWACrjeQCg65eZb3EVtI5d/6cWHMu7iXcxZpzCAsPYzdu3BBblpQsWdJhKi6J5H8Vhwv5m7duUnI0qVKlYpUqVUp0y7FQwUIsf4HEqRQaNmzIWrduLbacT+nSpVmRwkXEVtKBF0tbZMiQgeXLn4/ldcubqOSWz425ubmp68qyZvWa4ozO4datWyw8LFxsWeLu7s7SpE6jDsFKJBJdHC7kL/ldcorJ3uvXr8kMcsqUKaxcWfun/qfPkJ7lyJ5DbJmhc5tjxoxhffv1ZceOHhM5zgdCHj0OR/D8+XN284btSnbgoIHs6NGj7MiRI2+WDqvLtu3aijM6h6sBV+m9W6NkqZJiTSKRWEU1snEcHwz4wGDe5ozUslVLfv78eV63Tl3d/ebp8JHDfNbsWbr7zNPc7+fyixcv8kKFC+nud1aa8vUU8fSSTnBwMM+XL5/udbT0z9Z/ROnk5+XLl4b06tUrkavPqFGjdO8fyYW58H///VeUfDNw/YTuIbmIi4vjkZGRPDQ0lJZK5Sb2OIeXL+Lfw8tX6jKlefHyBX/x4sVbcS//Szh8MlT16tXZqVPO9T45eNBgNnPWTGpxKwJL5FoCFc8V/yvs3x3/MkVgiFxLXNO7spUrVrJatWqxZs2b2Rzscwbbt29nrVq1EltJY+++vaxpk6ZWe1PpXNMx/0v+TtenG/Pw4UO2c9dOtn/vfnY1UGmd89cslUsq5uLiwgoXLsxq1KzBOnbsyNzyuokjVBo0bMAOHjgotkyBysnvkh9zL27f78DzOHbsGDt0+BALCw0jM9PIe5F0L7ly5mJ58uZhufPkZlWrVGUNGjR44wFlRUizBw8f0O9D0sZ9FMFFg8TZs2dXMxTgxG/rP1vZ7t276bigwCB6VtlzZGfe3t70Pfbs0ZOVKlVKHPHmoIenNGCYj48Pu3DhAv12l1Qu9FywRNWJ3iSuBXfX1apWY8WKvZl57IPoBzSegt9uPEsZvbKcuXKaWGThXjZv2sxOnjrJnjx9QvcxYMAA1qdPH1FCkmQg5B3FzZs3ufICqaXl7PTJJ5/QNT8YaL3nkCZNGh4ZFcnX/7Fedz9SgQIF+J69e/j1G9d5CY8SumWcmTJmyshv3bpFv8URrFixQvc6Wipbrix/9PCRKO1coqOj+cRJE3mx4sV078U4YTLYypUrxZGcWrOKkNEti1S2bFn+5MkTUdo6aBmuX7+e129Qn6dLl073XOappGdJPnnyZH7p0iVxFvtAC1SpsLhSQfAsWbJYJJ/dPqIk5/Pnz+eFCiXcY8RxgwcP5vfu3RNHJo770ff5rFmzeGmv0jx9+vS619BLSmXE+/bty8+dPyfOZD+jR4+mZ5A5i+lzyJQpE58zdw6VUSoC/uFHH/KMGTNaXPunn36iMhLH4FAhr7RILV6YM9O4L8fRdWdMn8GVVqHFfsy6xSxSpSVvsQ+pTJky/MLFCzz6fjT3KOmhW8bZSWk18adPn9LvcATDhw/XvY6WunfrLko6l3Nnz73RTOPxX42n40+ePMmV1rpuGSSl5Z+gSuPEyRO8abOmusfbk5QWNf+/H/9PnC1h0MiBINM7V9asWUkV8+jRI/7e++/plrGV8CzDwsLElezj15W/UqWudz57E4SzJpjtpXbt2rrnQkJFd+PmDa70UnT3oyJWelviTBJH4FAhP3vWbN0X58z0zdRv6Nq//fabRUstnWs6HhUVxZUuoUk+Up26dXjE3QgSsOW8y1nsT640aNAgun9H0aSpbXcGX331lSjpPI4cOcLz5Mmje317EsZc/t76t+4+LU2eNFlcTZ/Vq1dTS1Lv2MSmT0Z/QjrshICLB4M7DxfTc9SsWZP7X/Ln9evXN8lPTHr/vff561cJ6+pRkfTs3VP3HG+axo1TG1QJ8eDBA16kSBHdcxQtWpT7+frxqlWr6u5HQu8mIiJCnE3iCBwq5N+kheKING36NLr+9n+3mwya4oN5/Pgxvxp41aRb2L5De/pDAF27dTXkp0RauHAh3YcjePjwodU/MCT0diA8nYnfJT9eqEjSBq5btmjJx4wZo7tPS8t/WS6uaMmqX1dx13Suuse9abJHyC1ctDD+GDMhX6FiBV6mbBmTvMQmqB9Pnz4trqYPGjUtWrTQPT6p6asJCTcQcH9Q1egd36hxIz7s42G6+7RUqUolcSaJo3CYkIfuM6kfcVLSkiVL6D78r/jz2rXU7mLp0qXpvq5du8Zd06t/9BDqj588prLDR9hWbTg7odW3e89uuhdHcP7ceepe610LKWOGjPzQwUP8zp07b5ygS7XG02dPed269lk9JZTc8rnp5iNBt3zs6DFxVVPwPO3VPbu6ulpVr5gnCNhdPradsY0cMVL3WEcmW4IWvVJYn+kd55CkVFzbtm8TV9Nn1apV+scqyaucl64O3jgNGDhAnEniKBwm5H19fRN8gc5MqVKl4hv+3ED3EhUZxVu3as0bNWpE27dv3+ZFihbhg4YM4s+fP6e8CRMn6J4nOZObmxu1vBzFuj/W6V5HS2jJ04BYEtKC+QvE1SxZtGiR7nXNEyq3SpUq8RbNW/AmTZrwfPltm3yap/z58+s+N+jEixYvqnuMcWrXrh2fM2cOP378OPfz8yPVzoBBA+gb0iuvpZq1a/InT/UHe2GK2axZM93j9BJ+c8+ePfnEiRMpoYVrq2LTElrp1hg8dLDuMeYJahNcb+p3U/nSn5eSzr1X715kBKBX3jjVql2LKnNrTJkyRfc4e9Ps2bPFmSSOwmFCfs3aNbovLTlTjpw5+N59e+l+YOkA4Q4wQGes57NXGDk7wR2wI8Efrd51HJl27NghrmZKSEgIL1CwgO4xxqlzl878wKEDpEaDfhnvKTw8nKxNMNCpd4x5qlajmriqKe/3eV+3vJbQat+0aZMobQkaCTly5NA9VkuHDx8WpU1BpWPP78e4EQSh3iAqKhxPT0/d47SkNVzMWfGLbasqLX0x7gurDYsjR4+QIYDecVpCRbjvwD5xhCXde3TXPc5aQm+7StUqZNGUNl3aJM99kFjiMCGP1ojeS0zuhC744UP6f4jAx8dH97iUSJ99+pm4K8fQ5/0+utdxVMqWPRupw/T44ssvdI8xTlOnThWl9VmzZo1dcQiGDBkijogn4EqATTUNvotfV/0qSlsH96h3vJamTVPHf8y55HcpwZ4AVIZ/rP9DHKEPzEj1jtWSnpCPCI+g1rleeS2hFzdzxkxxhHVuhdyyabqK9PHHH4vSpmBClz3WPHjH6FWfPHGSKpzYx7FkIopvyx6zWEnicIiQR2usZUvn6ALR8smWLRvZsyPlzZuXurqlSpXilSpW4nXq1KHUrVs33qNHD5pxC2saa5w8dZL36duHWhzoorZu25rMuXAO6JPLly9PHzkGbTGIWbBgQYOqQs9MMynpl19+EXeVdKCGwuCe3nUclapXr86fPX8mrhgP/kCLFy+ue4yW+vXvJ0rbpmHjhrrHG6fv530vSsfz6eef6pbV0qeffipK2sbf39+m6WbzFs1FSVNWrbaui9bS/IXzRWnrHDx4UPdYLbVu3VqUjGfBggW6ZY3T5599LkonDOzU9c6hpfIVyouSpoTcCqG/E71jtJTeNT3/eenP4ghJcuAQIX///n27uqr2plSpU5EFzHfffUc6w81bNvOzZ8/yC+cu8CtXrtDkocexjykCkqOBWeWZM2dokA2WKBs3beQ//PADnzh5IkWZQotQ754Tm7JkzkK25I7i3t17CaoakppgPaWHrcE2JFQAd+/ZF/Xq+/nf657DOP2zzdQtQ/SDaF6ihPWJbBA89k5siomJsXkua5Owxo0fZ1neyMIGJpT2zIfYsGGD6TnMknkvBqrIOrXr6JbVUuXKlfnTJ/bPxQi/E052/XrnQvLw8KDWtzlQtSTUmxk/Xp0HIUk+HOLWAJGgqlStwl6/su5MKrEof5jkbiBD+gwsS9YsLE/uPCxNqjQsV55cFDj65YuX7MXLFyxtmrTkbjZzlsw0ZRzT3Tt36kxeFvW4du0a27p1K3v56iVLnSY1i3kYw+7cucOi70ez+w/uU9BoBMCOjIqkPKX1zpTuJUW6wqOCkzQHPDLm6enJFCHvsIAme/buYS2at3BqRK758+fruofo3bs3W7t2rdiyZPac2UxpSYot2+zft581atxIbFmCqfeHDx9m5crFO6mDK4cmjZuILUsaN2rMdu/ZTe/SHKWZo8hidVo/FlH3o1iVKlWsOnkrU6YMO37sOH2TxnTp0oVt3LhRbFmy5e8trH279mLLOvPmzWOfffaZ2LJk1uxZbMznY8QWY5f9L1N0LLhDsIZSKbI2rduIrYSB+wE8z/0H9oscU3Lnzk0O6vANG5PQvRcqXIidOHaCKQ1CkSNJFiDkk8qiH96OgUwt7dipPzgI/vnnH91jkjs1a95M3JFjgAmp3nW0pFRo5DoArhuKuxdPVCrmXoyWZ06fEVeL59mzZ7xa1Wq610TKmiUrDwoKEqUT5ujhozbVYmhJm7dKp8+YrltWS7DGad++PVlcwcSwRcsWJqlVq1akbmzdpjVZyKTPYF2371XGi+YjGIM5FxUrVtQtj+Tt7U0DzfYAE0K9c2hpt4+pye3qNat1y2kJE49gRpxYoHfXOx+S0rDie/eqBg7GDB06VLe8lqZ9pz+eIXEuDhHy8K2h91KTO8GW+YcffxB3pY4V6DFrpn1eKZ2Zvv7ma3E3jmHUSOseG5GqVKtCajX4k1Faq7Rub9LK6xEYFMjz5LU+u7VZ02aJ8vSYkE4awticfh/00y3rjAQfMJjVaUzA1QCb9vYYL7IHqF4aNrQ+JoE5EOYV5pdffqlbVktjx40VJRMHxrf0zoeEv7Odu3aKkiqoSBo2sn7vadOm5QcOHhClJclJkv3JQz0QfC1YbKUsc2bPYR9/9DGtj/pkFHu/z/sGf+SDhwxm48ePp/UxY8ew0Z+OpvWUokb1GmIt6fDXnNRQtoBXwRw5cpBKK2eOnLRub9LK6xEaEsru3b0ntiwpUbIEeQO1l4SCruvFwo0IjxBrzgfqQ8QoMAZeLaHis0bxEsXFmm0iIiLYrZvWY/OW8ixFwVqMOX36tFjTp1bNNwsr+fTpU7FmCVSiuXPlFlsqUHNduXJFbFmCgD81ajjum5fYT5KFfFhYGLvoe1FsJSNQrxqpWIcMHUKC/dmzZyTcFy5YyHwv+pLuHWMFZ0+fZdOnT2e93+vNYh/HsnlzbesPnQnGD4oUcVwkqOgH0exywGWxpU/ZMmXFmmNJyC0zXAnbBdp7CjExMeqKFbzLeYs1FaUFSWMnyQX00a7pXMWWyukztgWt+T1bIyQkhF2/cV1sWQLXvxir0lAaaezmTesBYpTeBfMokfhA52i4RUVFiS1LIOTNg9ygorsTfkdsWVK+YnmL5yZJHpIs5K8FXmP37llvyTkNrSOo0LxFc7Zk8RIS8D179mS/r/6d8mNiY9izp8/Y4yePKYG1a9ayjh06stCwUDZnzhw2fPhwyk9OPEt6vrGvbj3w/G9etx0NCq1AZ3A16KpY06do4aJizT5OnDoh1nRQKnUPT1OhBYGEAfjkInde0xYs8PXzFWuWoBdT3ru82LINKkwIbmu4e1j6ztd6qnqgQniT7ww9isuXrTcaMmfKTKEgjYGveluU8Soj1iTJTZKF/NnzZ8VaytC8eXO29e+tFPC5dZvWbMuWLWKP2tKhpfinsWfPHtaqZSsWHBzMFi1alKzxXIFXGS9qDTkKdJNtWdVkzZaV5S+YuDi39mIcFEKPtOnsDIiunAYCy1qQEFC4UGEKvGEMLGb0rGY0EICjXbt2rHPnzqxTp06sQ8cOiU4IaIJjEe6wXZt24swqUJUFBQSJLUtgSVKggH3WJOcvnBdr+hhbFNkDnktiVGUasKqJjrbeO8K3BEFvTEK9+YoVKoo1SbIDxXxS6NHT+gCNs1ODhg1oEhAGdPRm/MHV8J2IOzRt3i2vpV8QDKJh0AwDaRiYNN/vrDRv3jzx9BwDBnH1rqMlRTjw2BhLu2ZH8Pnnn+teU0t//GF7hqcxmPFoy8Favbr1dAfTMQtUrzxSlSpVDA7pnMHt0Nu8cJHCutdGUhohNBPUHtq0aaN7DiTYnyM0pTEYqC1VupRueSQ8y8CrgaK0fWCQHPesdz4tffa55Uxt+APSK4uEyYyJsbCSOJYkteRhM+5/2V9sJS+epTwp9N/69etZi2YtdHWTsKXHZ/Y87jl78uyJyI0HoQEbNmxIy107dzFF6Is9zqVy5cpizTEE+AeINX3QZc+UOZPYcizG4ez0CAyyP5TiH+v+sKmTxwAm5iyYY966NwbXd6bOHgOlGJeyRokSJVjatAn3ZjDQiZ6lNTAXxLxHgJZ6oUKFxJYleJYnT58UWwkAcaywfdt2tmvXLnVDh/Tp01NIQmNwHVsDxngG5gPGkuQjSUIeH+X169YHipwF9IGIC4mPsW/fvuzZ82dijylKJUYTnWJjY61aP4SHhbMmTZqQmsdnhw8rXcq5gj5HrhzMo2TiB8Os8fzZ8wTfASpEZ1HCo4RY0+fokaNizTYQEiuWrxBb+nh5eYk1U2xNrnn08BE7e9Y+lSJULxC2T5+ZJoz1IB+NGnOgJnz10rqqTGlpizXbXA++zsLvhIstS8qWK0tqN3PKlLat64Zq0i5cGFWGn4+1PWmtcePGrGrVqmJLBQPGwdetV1DuJdzfOGauJOkkScjfuH4jQWsIR4Ngyz/++CP7c8OfrGvXrjYHqrAv7nkctehtzcbFoOyADwawJUuWsJUrV9qtQ30TKnhXoFaZo4BgsPUHBurWqSvWHA9mgBr+gHVU4z67fdhff/0ltvRBJdz7/d7sVoj11iCoVKGSWDOlYnnb+t5169aJNevAmqRD+w6sTu06rHbt2rTUEraREDzeHASitgZa2qVL29dogFUNAmBbA40PzO42p2492+8WfycnTybcmo+LiyNrs4ArtnuFCKJvzu3bt23KgZKeJcWaJEWAzuZNmTRxkkHvlhypcOHC/KclP/Fu3bvp7tdLcC27c+dO3X16CcGLoUe2FWEpKWnE8BHi6TmGw0cOJ+i5EXFT4Yr252U/v3H6aelP5EHR3P8KJkklFB9XqZj5seP6QT6g08ZMU73jjBPc0Co9R3GUKQgKkyWrdV0+ns8336phIvXAPbRrb12nrKVVv60SR8TTrq3145SWNw8NCxUlbTN3zlzdc2jJmh9/jDnZGhNAKlmyJD969Kg4wpKAgADepUsX3WONE3zZ640vzJgxQ7e8ltauWytKSlKCJAn5hOKJOjIprSJyEFa/YeJiZMLP/d9/244Xap4wzb1t27a6+5Kali1bJp7eG2LmlA3n07uOM5LSmtUd+OzVq5dueeMEITxk8BAKd4iA78tXLOejPhnF3d3ddcubJ3gHVVqL4oqW9OqR8D3A8+hvq36j4CKonC5fukwuETw8Ew7iDpcQWshIDaWXaOr/3SzkH7w1xr2wb9C1f//+JscaJ3z7cMdhDQS01zuOkrgnPP8xY8eQE7GgwCDuf9mf/jaGDR9ml2M7HI/AQHrAw6jeMUhwp4GQkJKU442FvNLF5u7F7fsDdVRCa04v31Za+tNS/utvv+rus5US8qb3JglTu+Hh0pEkZwjDDwZ9IK5qyomTJ+wOufemqVOnTuJq+pw+ddr692EmfOFhMWfOnImKZAaBaA7cEtsSkAhiYi/Vqlv3/5MzR07yvGoNuHpOKNiIccqcOTPPlNG+sIdaQvxaPVDpwwW13jFIRYsVtXADIUle3lgn7+fnx8LCrVsVOIMXcTqTXmybabOwiDAWHZV46wpbk0zeFAwYm3vuSyqXLl0Sa86nWpVqYs2U6tWqsx7de4itNwN6/cpVK1u16y5VyvYAJrygfvThR2LLDIgbI5QWOVNa8roDqXpgNnWvnr3EVjz+V/xt2pOX9bJvljHGA27fui22LMmbL6/NcSLMwp07b66u5ZEeZIggJgfaA2aSjxg+QmyZcifiDhkvWKNc2XJy0DWFeWMhf8nvElkdvO3cj7rPHjyyPqCVnFSuVNmhpoxKC4ndDrEuHBxNxYrWBzjHfTmOBsXflAXzFzAPDw+rlas9g3fffPsNzX52JEpPiVxk6HH9mnWrJgy62mvVhAYTfL9Yo0zZMgkK8LZt2tIzdCRp0qZhk6dMZvO/ny9yLAkKCmLh4daFPAae7a18JM7hjYV8StnHW2DWSjMnOjLaZispOYFzrYRmiCaGa8HX2O3Q5PltOXPltOlvB3/M69auY/nzJ25mraurK1uwcAEbMHAANRz0gJCwp1WcLWs29teff7EhQ4aInDcH8QgWL1nMFi1cRPeoh60ZqpkyZqJKyx6uXr1K1i3WKF/OPrcIw4YPY2vWrGH58unHUkgMMNmEzfyUyVNEjj6o6OAfyhrmbigkKYBQ2yQKBGCuV6+eie7tbU1Nmza1qTNMzqSn100Kf2z4Q/c6zkg1a9ek2cUJcdn/Mm/cuLHuOcwT3osWuPn0mdO6ZZCgQ7cWfNoaixcvTjBWqV6Cjn3kyJFcqUDFmfSBlYmtcIvFihbjz55ahkrUY9iwYbrn0BKiRSUGWMsgxKUt98fWEqJ4Tfl6CkVIs4eExoSsBT6XJB9vFBnqXuQ9mpgSFWm9i/m2AN8lL1++ZLExsSInZYDXvhMnTiSoW04MQdeC2L59+1i6dOlEjuNI5ZKKVA6v+Cv2+uVrmvRUv159sdcMfEFGHRS07Nb/sZ5t+2cb89njw2IfxapRvNKmJV820NN2796dbK61yFihoaHMZ5cPc0kt/K0o53zNX9MEJaiBENkI95MY4LgNEZnOnDrDDhw6QKotpaKiVnOaNGnoOkhQocEevlGjRuSfxh7PjfB++ffff7NHMY8M9uu4XwA/Qvnc8rFWrVrRdkIcOnSIWvN4jziH5m751Wt1khX8M+XPl3jfQ+fOnWM7du5gZ8+cpXT33l367RjbcknlQu8DvRRMJmtYvyFr2LghUxpFLFfOXOIMCXP06FGKTmU+qxdqN7hkhq8fqZNPWd5IyGMWHT48ZwxO/q+CmY9QR/zX9JMY4LwbcZc9fPSQZc+WneXKnYsqPHum+jsSzHjGhB24IEAjJWuWrCx9uvTMNYMrDYgnRrC9i2CwGenu3bvUOINwRwMIlQcqWrgllvxv8kZCHiP59sbslKh07daVbVi/QWxJJBJJ8vBGA69+vn5iTWIvdWrVEWsSiUSSfCRayMO22NfXepAEiSXQJZfzTpwvcIlEInEEiRby0OlZRI1xnFXg/yRwSOZe3DKqj0QikTibRAt52AZbBPlNtFb/v0Xx4sUdGtNVIpFI7CXRA6+TJ02mmYUS+/noo4/IPbKjgfnegQMHaOZxqtRvNLwikUj+14GQTwwd2ndApSBTItLPS38WT8+x+Pn58cxZMuteUyaZZJIJKVHNP9g8Xwm4IrYk9uDMQVfMU0BkKIlEIrFGotQ1Z86eYTVr1KQZpBL7wEzR40ePJ8l5lzXgHKpP3z4U4k4ikUj0SJSQX716NevTp4/YkthD69at2bZt28SWRCKRJC+JUtecPGVn5HeJgZIlZXxLiUSSciRKyF84Zz1osUSfWjVriTWJRCJJfuwW8nAydfPWTbElsQc44apSpYrYkkgkkuTHbiHvd9mP3Qq5JbYk9lDcvTjL65ZXbEkkEknyY7eQRyQo+PaW2E+lipXIpa1EIpGkFHYLed8L0ilZYkEINenXJ2UIDQtl076bxlb8skKa/L6DwHXK999/z+bPn0+xACRvjn0mlEqJipUqsgsX5MCrvSDi0ObNm1m7du1EjvPZt38fCwoMYqnSxNfdr1+9ZoUKFmL16tZjmbPoR+hBBKHDRw6z5k2bU3CTtx1EXvpn2z80P6Bjp44sS+YsYk88g4YMYst/Xs4WLlrIhg8bnuioUgmBigPxZGMex1AgGER0cuEuFPzaq5QXq1a9mihpCv7cYFILR38d2negICrOAgHCDx0+xKpXq24YG9qzdw9FoerVsxfLnj075aUEPj4+7Nr1a6x92/asQIECIjeeuXPmss/HfM4++eQTNmfOHBkMPClAyCeE8lHwrNmyojKQyc6ULVs2fuvmLfEEnY8i+HjdunV17wVJEd78t1W/idKmDBowiMokNpZoSnEn4g53Te/Kc+bMye/cuSNy4zl79iz9nu7du4scx3M9+DpPmzatyTPWkms6V96seTN+9vxZUToepYXKc+bIyTNmzMhv3rwpcu0jIiKCHz9+XPc36zHqk1F0Pz/8+ANtx8bG0neAvBs3blBeSlGqlHofiO1rjlIB8hzZc3CloqR7liQNu4T8xs0bDR+wTPalCpUq8FevX4kn6HwePnzI8+TJw5kL4w0aNOBt27alVLNmTa60Lg33tXzFcnGEyouXL7hXGS/ad+bsGZGbSF6LJcC68bYTOHX6FN1v7dq1qXIz5tmzZ7xW7Vo8f778/N69eyLX8WzatInuIXfu3IZn3bpVa+7p6Wl41nnc8vCLvhfFESoXLl6gfV5eXvz5MxEY3c5nNnniZJ4hQwa+9ve1Isc6eC4NGzakax05coTyQkNDuaurK/f29uaxj5MoPJPwnsPDwum+cubKyR88fKBmivPhvj8Y+AFXesLkm8mwT/LG2CXkp06davhwZbIvDR06VDy95OHixYt03SJFipi0fvBHg9ZftarVaL+bmxsPvxMu9nL+8uVLvmbNGmrlvyutptDbofynn37i+/fvFznxBAQEkHDbs3ePyHEO06dPp+f5Xp/3RI5KVFQUX/7Lcp4lSxba36NnD/76dbyUCgsN4z///DPfuXOnyLGBEHwazVs0p3Pu3bdX5FgHlffmzZv58mXL+ZMnTygPwh7Hd+zYkbYTxEnCNTIyki9fvpzuzxw8v2bNmpk2RqSQTxIJCnl8oF06d6GPQyb7048//iieYPKwYf0Gum79evVFjinnz5/nmTJlojJr1q4Rufbx+PFjHhcXJ7ZUYmJieFhYGI+MihQ5toGKITw8nCqVhEB3/XbobYNwSgy4z/v37/MHD0QL0U7wGxPDwIED6Vl+N+07kWPKvHnzaH+27Nn47du3Ra518FzwjMLCw0wqBWMKFy5MKqpHjx6pGTrFUFFbe25Lliyhe/pqwle0jeeEd4jejyPBedFrwDfyJtyPvs+jo6N53HPTb84Wjv4N/0skaF2Dke1zF86JLYk9pEubjpUtW1ZsJQ+Xr6jRukqULEFLcypUqMDqN6hP60qLjpYAA64Y3NrwZ3yQ8WXLlrHRo0ez69evU/yAhg0asg0b1P2wevh26resbt26rHz58qxatWps+PDhLOJOBO03Z8uWLaxVq1Z0fZRXWmnsz7/+FHtNwSBht27dWKVKlej5NWjQgK1YsULsjeenJT+xUaNGsZs3TSfnrfptFZ3fq4wXK1WqFGvZoiXb/u92sTce/NZPP/2U3Ym4w3bt3sV69+7N6tarS4Pk6zesF6Ws8+LFCxYYFEjrZcqUoaU5nTp3YpkzZ2YPHzxk/v7+IpcxpcdE9+5/JT5v46aNrGnTpszb25tS8+bN2Y6dO8Rexn7//Xc2aNAgpghOGrgd98U49uefyjN0YWzqd1PZpMmTWMDVADbs42H0jk+cOEGDq3iv69atE2dRA/6A/Pnz03HVq1en99K4cWOL360IWDZxwkT25fgvmVJhilwVfBc496+//ipyVC5cvMD69e9H30S5cuXoG5k5YyY9L2Pw/nG8uZuUvzb+xVq3aU3PAO5AcF8rf1sp9sbjs9uHjr/sf5kpPVjWv39/+lZatmzJFixcQM9IYgSJehsEXAkgPR6KymRfKlSokN2DY47ivffeo2svXLhQ5FiiCGMq06VLF5HD+WdjPqO8775TW6RoERUrVoz0+G3atTH8JuUPk/a1aRufZ5zq1KljoQPXWrNIOJ9LKhd124VxRfiLUiq/r/mdBiOxP3Wa1Nw1Q/w39+Pi+F4RWqpFixal/MDAQMrD2MdHH39kKG+c8O3u3GGqGqlTtw7t69qtq0X5VKlTcR8fH1FSH/Q08uXLx11cXLgiwEWuKQ8fPeTlvMvRORcvWUx5T5895aW9SlMeelZgy99bDM8FrfSMmdVngGdx5rQ6RlK1alXKM06TJ0+m1n+aNGl49uzZedt2bQ37rly5Qs8M66M/HU3nAEplS3lQ6WlltYTfsvGvjaKkGqsA+bnz5LboGSgVL+1TBLrI4fzo0aNcqTwM59N6jUjG9wAaN2lM+Tt27BA5nM+cNdNQ3jxpA8ca/fr1o/wOnTrwdK7pLMr/8ssvoqQEJCjkV65cafEQZbKd6tfXV5k4C6gaqlStQtfes8e6LnrCxAlUpmvXriKH885dOqvH7VaPg2oBAiZdOvWPR2mpcqVVyu9H3ecTJ06kvLx585IeH9Yh27dvNwgN6Kk1tv2zjfKQoB4IuR3CldYr79BRDTpTr349gwoIg5GwRkL+kMFD+LXga6Su+exTtQIqWKigQf0SFBREg4+epTz5k6eq8NEEWvoM6aliwX1dvnSZ9+zVk/KVlqVhvAEVVZGiRWhgT7veieMn+MEDB2lAEnnffPMNlbWGr68vlStWtJjVwV28E6WlTOU0IQXrGFipoZLC78F4SZMmTagM1D6oPELDQvngwYMpr/d7vem4bdu2GSokvIuVv67kISEhNA6TIX0Gw2+pUqUK79W7FwnlwUPVc6z6fRWdAwPz2u/Du/3+++/pOZ08eZIG6pGvtOr54yeq2gqVMPL09Peff/457dN+F9RwJT1KUp7SmqYKDGqg2bNnUwWm9Gj4tcBrVBb3hkYEgt0EXQuiPIxPaL8B7zw4OJjSyJEjKQ+D2zifRuNGaiWB1K59O35g/wF++tRp3rCROtDcqVMnUVICEhTySrfI8EBlsi+NGTNGPL3kAYIhR84c1KrT/nD0GDt2LN2fJuQhiPCHjz/EwCC1VYxBPa1l2bdfX9KPgmvXrpHwT506Nd++Yzvlaaxdu5bK12tQj/TJcS/ieM0aNSkPAsEYCDrcJ1qOSref8nr16kVlUQEYo3TzeQmPErRPq7wOHjxI2926dqNtCFn0nJA3d+5cytOAwHIv4U77jh87TnloeWutzC/GfUF5Gl9/+zXlT/12qsjRZ8Of6vgHBgjNrXs0YL2iVbyaMLx4QR0cb9miJX+t/IuJjaH7wyCt8Xmio6KpnLu7u2EM49PRn1IeelQaq39fTXlI474YZzJwjp4V8mFOCi77XyZhizwMWhsDc9CsWbPSO0GLHOBZouzESRNp2xitR7DLZxdtjx8/nrZRqaEyMUYru2zZMtq+desWbVesWJHeL34fKmHkDRs2jMoYg8YA9q1apVZWD6If8NKl1N4QGijGaBVThw6m39F/HZs6eWU/C7yq6h4l9lO5UmWxljxEhEew6PvRzKOkB1NaPSLXkpiYGFoqVTsto6OjSV/sWdKT5c2t+ti5fPkyua9A8PH5389nObLnoPxNmzYxpRXG2ndoz1q1aEV5GtAhp3dNz65fu85exL1giqBgx08cZ0WLFWXjvxovSqkovQDWs3dP0gdDV6u00OjcSiucfT3la1FKRakMWOdOnUnHq1Q8lKdFJlNa8rT02eXDlN4HK+lZkilCgvI0MmbIyBo1bETrgYHqd3w18CqNMxUuUpgpwonyNB49UoOv5MyVk5bWOH9O1W1Db4xJb3rgtz17+ozW4agOXPS9SMuixYsyF/EPentFOLOFCxbSPpAtRzY2fMRw1rlzZ5Y6VWqKAAZ9N8B70bhx/QYta9asyabNmMaUyou2I+5GsOs3rjOl8mAl3NUxmtCQULpOtarV2KCBgyhPo1jxYhS9DH/vkZGRlKdU6rQ0H3PAmIwiqOl3Y+wEz0ypbGiy2ZTJU5hSWYiSKvgNxu/vasBVWiqteXq/SiXETp06xXLmzEmTn8xp2rgpLbX7gZPEGzdvMKUHw7799lvK08AsZ1CkmAyab4xNIX8v8p7hw5TYR/r06ZmHp4fYSh4u+qnvSOky2/SVg4E74JbPjZY3b9ykmZulPEuxrNnU47Q/wh49erAcOVQBD06eUAfJXF1dacBt+fLlbOmypWz5iuVs5cqV9EestOBJuO3fv5/Kdu3c1VBJGLPq11Xs+PHjJCQ3bdlEgcgb1m9Ig4DmzJo1i508edIgrDHQBoqXUIXdgYMHaKm07OnezIHwAEqrmZaasMcAn/mzunhePTeiedkiICCAlhjctcajB49IGILChQrTEhUo0GYVQyi///77JFxHfzqa9e3flyohCMxFCxex2bNn0+AqKmdfX1+Wzy0fK1igIB0LtHeFQVlUGBp4z+Fh4ayUVymWOas6y/n8RbVi6ta9m27Qd+054V4AZssCfBvGoEINDg5mJUqUYLlz5Wa+fr7s1s1bVFE0a95MlIoH94b3N+CDAbTte1l1j+Ll5UXLf3f8S0sMGBcrWozWjXmt/AN37tyh5e3Q2/S9NGjYgJXxMq2AAvzV9+JdzpuWEhWbQj44KJiFhISILYk9KF1sErbJyZUrausWf3gQEHqghXbmzBla9y6r/hEYKgelFayBP2AAKxUNCO7gG2r+urXryJoBf7xDBw+lVuFnn31GLTy0OjGtX4s7UK58wrFt0foHderWoWVC+F9SrVI04aO1cNGq1OPe3Xu0TJcuHS3xTQOthajx/PlzqvTSpklrIdiMQUzd68HqPWuCSg8ISQjntOnSGgLHaIKzrFe85dXIESPZRx99ROuo/OrWqct+/PFH2taAwIYbBPTUcuVS3SDgnfhe8qUWtbkLhdu3bpOwrlyxMkvlov6Jo5LAt2HN9TXiNwP0qHAs7hUeVLUGgUZ4eDi9a816DCEoQe1atallnhDXA9VnV66s+m3ACgigta+LWucYeldBV9XrNW1i+v5wz6ggQZVK0r23MTaFvGZyJbEfDw8Pli1bNrGVPPheVFtHxsLanGNHj1ELDz5A6tRWBSpaYaB06dK0hC8YqOegXjD2YQN1AYQb8gcOGEhC3Th98cUX7KuvvmJTpkyh1jRME4F7cXda2uLho4e01ISXLWIfx7Lg68HUAoZ/GHA/ShVOhQoVoqUx+MPX1DuofIH2m81b4deCr7Ebt26wQkUK6Z5LA78NKgM8R09PVWWkx+Ytm2lZ3rs8K1KkCIuLi2M3bqjqFeNr43lBqK9atYry7927R2qnCRMmkD8ccOnyJVpC/aUJ0qj7USS4cW74JjLG75KoTMrEVyZ+vn7MNZ0rfZ/mQGjDLDJ1mtSscOHCVKlA6KOxkt8tvyilgmsCmEiC8NBwWtqqGDVevX4Vb3paVm2Fxz6KpaW1byXwmlq+YEG1B3PytNqjLFxM7R1pPHj4gMxIM2TMwPIXML3n/zo2hfyp06fEmsRekts+HvplzV7cWjcVwuKHJT/QepWqVVjJUmplEHxNbdVqete79+6SEEWLMXtWU+dVEFJQRc2eO5scRhmnGTNmsKlTp7IhQ4ZQ2VevXtFSa0Uag677119/Tc7UwKuXoqyObht62EmTJrE/N6h29dBBoyUJQWTs2AstVE0fbcztkNvs/PnzLHOmzNTLQWsdKpM8efJYOAZDBQjbcO/y3jadYUVERFCvCHr1PHnziFxToL7A/ADQokULqhxDbodQSxOqIDc3NxKiUFVpLWGobQ4fPsxGjhxJ23iu2ns9e+EsLY17DmjRvnzxkoS8uaMxTRC7e6iCMyoqitQd6FXo/Tb8nUOwQ3+PXocmSKES03TpGj57fGjpXkI994tXwgZepwMJ+/pvvvmGLft5GW3HxsRSBYRGkFYxYZwHmF8HPH7ymB0/dpzWS3upDRE4SUTZEsVNVWp4nvie8fenqZ4kKlaFPPReFy9IfXxiqV27tlhLHkJCQ6gVCkGmdYHN+XXlr2znvztpHWoWDJJiwAyqGQggBDcBEKpQA1T0rsgyZY4XmhDAaCFB/QCVhjkDBw0kferWbVtpW9PlX7+pds2N0Vr82qCh1oK/FWoZkGbe/Hk0uHbgsKp3h+oQ32WlyvGqmYwZM1KLHYON5iz9eSmVr1W7FglDXBMCDy1mt7ymaohrgerAXvXK1WlpjYArqt4XLXQM7OqBwWaoVzAeMXDgQMrDADMGYiuUr0CVJQYbO3fsTBO4NDBovmDBApoEhAop5qE6jnA9SH2OxjroS/5q6x4Tv4wrSAyqo7eCFj8qQ4DKAhUTBsXNJzYBTC4DqJDSpE5j6O1gUpIx6Nnv+HcHnVtruRfIr3qQ1NRmxvyy8hc2efJk9tdff9E2Khro9CGIMSgMcuVR37/efaGihOD2KOHB6tSqQ4IcA8h58+Q1DChrBAaoLX70PvTGZv7LWBXyeBnowknsBx+u1o1NLtACe/rkKc10zZI13uUuhBveH/xxjxgxgvIwq7Jvn760jj84tDjRstQGRzW1AFryxqAiqOCtDoqu+yN+BiU4ePAgVSKIGla+XHnK0wZQoYKAANaAWmL37t3UAm7eojnlFXNXB9v+3vQ3e/hQVd0AtPRXLFtBAqzv++o9a2MP2nUALEvA+vWmMzYx+At/5GDIULWHYWyhQi3a+FszDExqrV9raOcwr1Bx79BjD/1wKM1QBZ+P/dygJtLuXVPxaILo6LGjtNQDFSuen/Z3CIskDcOzUCobYzAGERYaxnLnyW0YG0LljZ7Ys+fP2No1aylPA+8Tzw6qmg8++IDyIEhBKiPjO1hijf5kNKnt0BPRfhesZMDBAwdN5AUqihkzZ9D64CGDaYmeDH5P6VKlmWt69fdr38qG9RuogtLAuSZPmEzrAwcPpOeF46MfRLNChQux7DlMey8XfNX3ovUwJEYoD10X5Y8RT1ymRCTMTITteXKyZLHqjyRX7lxcEeKUYL8N22P4TdHuDfbmmAmpsW/fPsrv0b2HyOG8f7/+lIfJNuZs2qx6XVRacfzL8V/yQwcPkf23ZqOutF5FSc4PHz5MeUjt2rWjGZ8DBg0wTHhRKh5RkpOtvDYRqm69uvyHH37gSmuf58qZi/KUCkqU5HzwIHWCz/oN60UO5wcOHqA8JPiTgaO1ryZ+ZXCNDRt8pXdCZSdNnkR506ZPo21jtIlLmsdGa+DZopzSkuWtW7ambThEU1qnht+HNGjgIK60xsVR8bONf1qq2qhjchnOgbz+/fvzY0eP8QsXLvBPRqvzUsqXL8+Vypvs7ZVKl/KUXg3funUrTejSJpXt32vqpE17HrXr1BY5nE+bOo3ylMqVlh8N+4gmOY4aNcowY1SpnERpzr/5+hvKw6xeTKCbMGGCYb6Bi4sLL1e+nCipzrXAJCrsg2fN+Qvm8+kzpnNFEFNe0+ZNyVka0Bwdfjv1W9oGmNeBGbvIx2/67bff+LRp07jSu6S8GjVqGDxVwlYeeR9/9DFtG9OjVw/at2q1ak8viceqkMc0dzw0mexPffr0EU8v+fjoI/3p/FrCxB9MfoIwNWb+9/Np/+RJk2kbrgHwB4U8zII0B5NWrLkO6Najm4UHy88+U2ermidMFDN3wbxg4QLdspjdqc10BVUqVyFBan5/U6fpe0nFfRkfj+eA/K3/bBU5KpjAg8lkOXLksOlMDAKtlPCDbi2h0oOQ02bzajRq2Ij2YzKXxj9b/zFMUDJOEMZKT4bKoILq1KWTYR8mEeF+4R5Bad3ym7dMfdL/+uuvVO7Djz8UOZym/yMPjulqVFffsXFq1aYVORXTwExaCHjjMl6lvfjsObPJ5US37upENA3MyMVkKuPySHVq16HJTxrwyIl84wldAII9U+Z4NwhaatigIc1w1pgyZQrlL1q0SOSo4Ns0fLunLL/d/zou+J/ycCxQalX295a/xZbEHhYuXGhQjSQXsF/HoB7MF9HdxSArBjxhyeCa1pXUR5rO3ZhLly7RRCioAKCvxgQoRA3CQG6bVm1YmnT65nArflnB9u7ZSzp9DPi1aNmCHHwZ22lrQI2zy2cXDa5hMKxV61asa5euYq8pf2/9m23cuJF0sxhfaNS4EdlWG5uEbtu+jSJdQWdtPtAKh174XiPvRZI6qGWrlqxdW9OoXEcOH2Fhd8LI/M54DgB+M9RImTJmYk2aNNEdBAT4HQcOHCBrFIBnjucMlRLmG2B8oWKFikypMGi/MTj/k8dPWJOmTUzu/djxY+z31b+zO+F3yCYcevQBAwaQ7l4D+nw4jYNOGo7UunTpQtGlcF38Fs08FCgtY3bq5CmmCHOD6gKqr5hHMax9+/Y0cKwISRpbgDqoYaOGrF/ffhYDspgLAEdieJ5KxcK6d+tO96f0JMhqx1xff+ToEbb297WkBkydNjVFo8JAvKZ7BwcPHSR1EtSG5hZoGJCH2gjjB/iu4Nzs/ffeJzWSBsYIoVLE+4fKSAOD93v37aX32Lp1a5PnIWH64f8w6IMXq+n9JAkDwaB0nQ2eHiUSieRtQHfgFbbFmFkmsR+0TDDDUCKRSN4mdIU8bIlh0yqxH3TT7ZnQI5FIJMmJvpC/pPrYkNgPpovDxlgikUjeJnSF/IlTJ8SaxF5suRSQSCSSlMJCyGOygeYLRWIfmMGY3O6FJRKJxB4shDx8S2Dqt8R+4KkvuWe6SiQSiT1YCHl/P3/ycSGxH/gUyZAhg9iSSCSStwcLIQ8vb5LEYdUXtuTdRneaoETybmEi5J/HPWdnzqmBJST2U76CqZMoieR/CcySxUxaeCiVvHuYzHiFr274rDb2BiixDTw4Hj5y2CIW5rsMvCnCxzj8ecOdLoKMGAe6+K8Bj57w4gj3y3BlkBjgigBeIQsWKmhwpQD3CHAjAbcCcE2QkkBwY4Y7vDzC26g5cDeAsH5wD7xrxy6WOYsaTlDyDgEhr7Fr1y5y8iOT/am8d3n+9OlT8QTfbW7evMn79u3LM2TIYPIblT9sciymCCdR8j/Aa3UBZ2C1atXixYoV43fC76iZiWDcuHE8U8ZMfNPGTbR99+5dXrhwYV6rZi0eExNDeSkJPHfmzZuXvJLq0bx5c57KJRU/deqUyJG8a5g0I2QkqMTj6eVJJpTvOohQBKdev/32GznggtOyKpWrkDMtzH5GUOkvv/yS/IH/JxA+yuBw69ixY+T4TQuKbS8Im3j69GnqEeUXIengjx7BT17yl7rRrJITcsy2ZzcFONECjBjzzz//MKXhR37hq1atKnIl7xomQl5Ggko8Vau8+x8/uuuI7uR/2Z/lz5+fAkscP36cHTp8iCIYKa17Kgcvm+i+/5eAOqVTl05s7Jix5KUyMTx99pSCZyDikxbuDnFWu3bryoYOGWriYTMlgBoKXhuHjRjG8uXPJ3JVEMVq/ITx5GUUcXwl7zBqg55T17FSxUom3XSZbCcX5mK1m/susWjhIvo9ObLn4CdPWPrjfvXqFa9dqzaVgfpBYh8BAQH0zBCQxNy//LvA+QvnxZrkXcYw8Op/xZ9VrlyZanCJfaDVe+L4CVa4iGVXN7nAwB58g1O4t5KWrhXOnjlLLbZy3uVY1qxZRW48sbGxrHz58hRubeb0mWzsuLFijyk//PADGz58OKtRowa18jWgkli7bi07dPAQBfBGWLYunbsYwvJpQAV07tw5VrhQYXpeOAd6CfC93rZNW0Mwavh8P3j4IMufLz/r2LGjRZBqXO/PP/9ke/fupeuhBYog2FrMUQ34QUf0fgSAfhb7jC36cRGpTEaNHEX7MeCIAOH7D+wnH/U58+Rk/fv1Z16l44Nlg6tXr9IzxlyIrNnU5wfVzc4dO+nYhw8e0m+Gj/PmzdSQhhqbNm9inTt1Zl26dqFrwd9/gH8AzSqHKgznwTMhjBr15Jv/tRpOsky5MtTif/L0CduyeQs7eeokhXtECDxcU6l8xVGm7Nixg9QtePe4b7yTOnXqiL0q8FOP9168WHFWoKAaqxVAjYOwgP6X/ClkIDys9unbh8L2GXMv8h4LCgwiowOU2bNnD/mVh/qyVYtWFBRd8hZAol5B+YCo1SGT/alu3br8RZwa2iylQE8iVapUvH79+oYwdxoIKZfeNT13d3fnkZGRIteUdevW0W8pUKAAvxtxV+RacvjIYa78kXOl+264TlhoGG/dqrXFc8FA45o1a6iMxsaNG+k+vxj7BSXj8q1bt+ZRkVF8+DA1RJ6Wataqye/dvSfOwGm9fbv2JmWQFEHPd/nsEqVUJk+eTNdDqEJEU0K5Vq1a0T5Ef2rYqKHFeRDV6cSJE1QGIOJQnbp16Dxnzp6hvOjoaN65S2eLY5EQQs+4xa6Fu5v63VTaxiAuwughAhUiVilC2OIcSKlTpza8U3A18Koh8pFxQijGOXPnUBmNR48e0WCqeVlEkfr5559FKZXhI4bTdZYuXSpyOPfz89O9lpubG9+5a6copTJ33ly615mzZnKlQjYpj5B+O3ealpekDAYh/+WXX5q8JJkSTgMHDxRPL+U4e+4s3QssNsxD8A0dOpT2QeBZY8iQIVTmg4EfiBzrQEghIXwf4oy2bNWSjkUFgdBsCMsGawzkIW7rlYD4mLJfTfiK8hFmD0tYrEDoQlBB0KDCRD5i03Zo34FnzJiRthGLFCgteN77vd6Uh3i248ePp3iiEMLIU3oH/O69+EpKE8RaGDuXVC78//7v/6iCqt+gPuUhjijOgVi1VatVpTxcX4vNGhERQcItY6aMBkuYsWPGUjnPUp587Bdj+cyZM/ngwYNJiCL/4IH48H79+vWjPDSgAELZYbtKlSq0/ccff/AyZctwpZdFMV2rVqlK50UZpGnfTaPf3aylGle2cpXKfPKUyRQDtUMHNaQf4vgah3YcPESNg5slaxZ65it+WWFSNjg4WJTkFFMX+YcOHaJtVDy4F+R5lfGiWLjz5s3j1apXozzcm9ILobIAvxv5GTJmIAusYcOG0XspXlyNzwrBL0l5DEK+RYsW9GJksj8tW7ZMPL2UI+R2CLVkIWSMW+u3Q29TMGvEeDWP76oB088aNdVWG+J/JobFixfTcTC/O38+XncLoQThjX3GAZu7deumPjcXxhcsWGBo8bZvH98yHzN2jMEcdeTIkZQ3a/Ys2kYAa2wjJip6FRoPHz3k3hW8aZ8WgDzueRyvXVsdQ0ifPj1fsmQJv+x/mYT3vLnzKB8tav8r/lQe4Dm65XWjfadPn6a8U6dPUQWECglE3ovkmTOpMVkvXLxAeRpa/Njly5fTdtyLOEMF5O+vXufff/+l7fd6v0fbeAaoNB/FPKJKBL8dJqwoU69+Pf7yxUt+7vw52obgjLofRcdpVKioBtDWeh+IXYtt9N58dvlQHvGaU2Bv7Fv6k9pqR4sfPbz0GdIb4rtqQcQh6EPDQikPRN+P5pUrV6Z9q1evpjwE527USI1bm9ctLz9xMr4HtHnzZsrHt4XvQZKykHXN/cj7ZEInSRxvw0zXvLnzsgL5CtBkHZjCafz151/s0cNHTBE+rFixYiLXFEXAsBvXb1B8T+OYogkBqxFFyNP6+K/GswoV4o+F/njQ4EG0fvrUaVpC/w3dL/j000+ZIsANE280H/w9evRgs2bOMpijpnNV43QWcFN1xatWraLluHHjaHKWRtYsWek3AsStBTB7vHbtGq1PnTqVKT0a0rXDimjuvLmUr7SSTXTMsH6p31AN3YjIaCA8LJzGALRnowhj1rpta/b1N1+z8t6m7x5jG6BokaK0VCpciqGLWKSwrgFw/gc0t9R4BhgnyZI5C1MqL6YIR7bm9zVMEZpMqZgovin8SLXv0J59++23LGeOnHQcwLvD+BmelxasZslPS2g56pNRrGmzprROuCjPt1sPWr19W434duvWLTLlxDgOJmndu3ePrf59Ne2bMnkKK5A/XkePMYdu3bvR+vET6njM49jHFFwIzJg+g2K6amimoTDDTWkLIokCJP3Ro0d52nRpqfaVyb7kls+NuvNvAy1bqGoTTQf65OkTrgheysO7tYYiCKkMdMTGUfUT4tw5tXVJx4VYHnfy5Enarwga2g4NDeW58+SmSVY3b9ykPAD1QCnPUlRWER4iV0URuJR/5MgRavEqgpIrAoP7+PjwsPAwNYWFcUWg8ylfq1H8Bw5Q1WfHjh2jbaiw0GLV2LFjB+Wjpfr48WORG0/A1QC+Y9cOOjeAKgbl58+fT9sa0NVfvXqVxjygTsKYAsqhN6X1mnz9fCkPrV1YJ4EBAwZQ3tq1a2nbmIsXL1LPi/avs9wPVZwiVEkdBLVTpcqqJVzZcmVJdYZJVmiVQ80VGBQojooHvZAdO3eQxQ8w9CreU3sVmzZtou1SpUvpWgIt/Xkp7VcqcNq+fOkybXt4eFhM6sL9Yd8333wjciQpCbXkrwZclZ4nE0m1qtXemnB/+QqqNs6KcKLl4UOHydGc0uUnaxgT8Ocn0FpZqeycWg9rEKBZhGCCDKxlzIFFByGuhdYjrF3QajS2RILVSlBwEHN3dzexaol9HEvRydDKLe5enAUHB7MH0Q/QICEbc0yxL1e2HFMEHPMu502tcgBrFHA9WO01NGvWzJAHzpxR/TLVq1uPKcKQ1o3xLOnJWjRrQZY94PyF87QsUrQILeHbadq0aUwRsMzT05PVql2L9e/fn23fvp32o8eUK7f6TcDiCShCkJ4vLIFgqQP0egHDPh5GPa+Ph33MevboKfaoFjBomXt7e5MVCwLFw8rp3Fn1HaC1DJcEvr6+1LJHhDJYy5iD+2rRvAXdN9B6OlovRetl1KtXT9e9QdzLOFpq3wpcXwBYUaEXYoy2r3RpU2scScpAb0xGgko8EC5Qc7wNuBd3p2VUpBoHYPny5bT88MMPLQW4Tu8ZwtOWoI97EUcTotq0bsPuR99ndyLuUH5JD/1oWBDKQPPVcuPGDVrCRNe4+w6h9+rlK/KLY2zeGRgYyKLuRZEAg8CFQHr56iX5eoGpXuZMmZnSaiX3zmlc07B8BfKxokWLMvcS6nM4e/4sLc1nad66eYuWqFQSAs8ElVmaNGkM5pkQrl999RUF1SlTtgxr27Yt5UH9BFBJ4N7ABV/Vm6tHCQ9aRtyNYFcDr9Iz0Wa/akycOJEmnlWvUZ3NmDFD5KoqmR49e7CFCxaSuguVS6fO6sQsVHZAuzdNHYbnYM93qVUSxUuoFULIrRBaovLUIzw0nJaaS23t98H81hzM6sV7xvuTpDz0lw1bakniULq1Yi3lKVG8BC3R2oWN845/d1CrskvHLpRvDfzBwr4ett7QyVpj3959pBPHd5IhfQYS+sB8lqSG1mjQWo0X/dSZ1LBZN0Zza13CQ71/DYwPwaZcG0tAyx40bdqUXTh/gV28eJH5+fpRgi03ZuqiJTtkyBAqp7UkzccitPPkzZuXlsZA375l6xYStgC9IjgWQ9nixYtT7+DXX34lfTNsyDE/YuvWrWzRokWsSdMmdAx07VoldumiOj6gOa67d/ceuxtxl4LLGFdoGzZsYPPnzyfhj8oZ+nmNAwcPUK+sUKFC7OjRozSHYONfG9nMWTMN3x/mPwBUSsC456KBCtJntw/buWunyFGE/IVzdK/FiqrPCDp2YE0w47kDODAE2hge5g8YAxv+4GvBNH5gT2UqcT6p7kfdN7QCJPYB4Wg+2SclKVZc/UN98OgBW7V6FXv46CENfrpmcKV8a0DdhMHHV69f0eQia/zwfz/QsmPnjvTbU7uoLcXI+5G0NAYVzbat22i9br26tDx/TlV7mE808rus362/5CcEpNJaBtmzqROiXLgLTY5CglBEgqoCE5yg5iA1gyLr0PJHvlbJaGTLno2WN0Nu0tKYdWvXsY7tO7JlPy+jbfQ+Hj16RMIUvxkuuF+8fMHq1q/LenTvYaKi+P3332npWUq9HgbBb95Ur6F577wWrKpHIPS1ljZUOsOGDaP17+d/b9GKvhmsnqP3e71ZrVq1DK1oCPTdPrtp3busOuEoXTp1oBrP3xyoqTBRa8SIEbSN34UBd7e8boYJdJpfHrgVNif4ejB9H3i+TRo3oetDkAPtN2tg0BoNBkzW0gacJSlLqsCgQBYZZfnHKrEOdLRvUyulYMGC9AeIGaRz5swhYfbee++JvdbBMZog/nHxjybWORrLli1jW//ZSpYe8LcCtNbc0UNHyWWuMbPmzCLLDXTjGzdqTLpoCDOoPYxb1jhOE2Lly5l2+TXddcUKFWkJvTZanWfOniGrFWM2btxI96i1NG/cvEF6bFiomLdKNWuag/sP0lLjwYMH1JoGsJ4BmhAzWB2pwxHUkzEGqgno5PH7NNUFro+xBgg6TZ+PngbwKKmqb2Bx9OFHH5JAxCzjfn37Ub4xca/UHlPaNKY68i1/byHLpZw5ldayUFFpevhjJ47RjFpjYLUEOnXsREvMBI6OjmZFixUl9RfwKqW+033799HSmEmTJpF7ZOj08S5QEUClhvGVPHnzqIXEZ3At6BpZJHmV8TL0aiQpzKrfVuH1yJSI1KNHD6Ux8/YQFRXFS3qUNNwfZjzaC2y4MTsRx2FCEmbQhoeH8+s3rpPVitJCpH1wNayhTRJC/ujRo3lISAilKd9MITt45G/Zok4AwmxNWJ0oApesQDQ0l7vYZ+zCF+6MFcFK5zh79izlwdqjeo3qlIcJRrAEgm33vzv+pYlYyF+xYgWVxaxMbLdt25a2jcGsVexDmjBpAldaqGR9pM1+rVipomFC2aSJkyhPmwtx8fxFsu7BJC9YMeEZ7Nm7h5f0VJ875iMcPHSQv371mh85eoTyWrVuZbAT1+YJKAKatjFpCNuYaKVUzGRfj5mnPy39iS9ctJAmuf299W8qU6JECX76zGmy+sHMYUx0Qn7+Avn5pcuX6PnAUgnPGPmYNIaJV0GBQfzDoR9SHiaQBV0LomtjTgTyBg6K/07wrJVKn2awzpk3h+ZZKBUdzeJFWdf0rgZLLbgdRh6esbkd/PTp02kfLJMkbwdMbwq0TLYTZgK+TWCSjzaLE6awxlPz7WHJ0iUmvw8TnFwzqDM4kVCpPX5ianK4+Ed1MhQSBJU2QxVp4qSJohQnYY+8mrVrihyVo8eOUn4ZrzIm7hhggqidE6aXGtu3bafZsdgHc0pMZsI60gf9PjDMUp09ezblYTaqOTBlHDRokOG4NGnV8yGhwoEgBRBcjZs0pvw9e/ZQHu5Rm+GLlD9/flpCuGv3AuEbejuUr1qlNpxGjhpJxz6Pe86LFilKeTC9fBz7mCoLbFtLmEiGCs/TU50BCwGcM1dOWsf7wQQ4rHuX9yZTUvB/P6imi0iokNKkVn8f1nFPGloFo0000/h8zOeG4zGDVavgsVyxXK1EAWYII1/piYiceLp06UL7YJIpeTtIfTXo6hRpPpk4PvnkEwt9b0oCHe+B/QdoILNRo0ZszNgxdptFArhLxqAoTB0VIUWDt7B6qVCxApswYQKbNWuWhVld1WpVaUBS6UWwmJgYprT0WN3addnU76ayEcNV3S/AACZM+6A+Mp5whQl4UdFRrFOnTqx27XgnW1AFQIUBp2WtWrUy6K+hO4ZFU/CNYHKKBXUD8saOHcumz5huuL+QmyGkOoEeG5YmxkB9ABUS7gcWQDBdxEBqy5YtmdKKZpUrVaZyMBUNvBpIKhBYt2DCFZ5ng/oNSNcOlQQsX5SKgK1YtoIckGFiESyBlJ4G/QY4PeveoztZ1+A6t0JusWpVqpGV0v0H92kQFvr6ShUq0WAsnHlBXw9TSaSePXvS84WFEFSq0KGnUv61adOGrVmzhlWsWJGebaWKlVjnLp3pN2NCEgY8oUPHWJvy980aNGhAg8PahDGA3w5LJaiI8uWLHzyH3h7qGzxbfANwbNawYUNyMY1raOB+0qVNR7/P2MIK17vsf5mcnfXu3dtgXSVJWVz69O2DyC9iU5IQGHCDyRtmMr5NQN+6ectmstYw/oNODLBvhxUJzP3y5MlDOnQIQVtAtwydNgQoBnKxdCbwZqmNHWAAVtMpJxYIYvxeCEeMaSQGjDkA6Ny1vx0IOOii9cwXsS8pzwXPGHp+VGQFCsTPRIXdPvzTm4P3gUoIbXL8NqXHIvbYB55LTGwMhTqE3l/ybmNwNSx5dzl67ChrUK8Bc/dwZ2dOn7GYnCKRSP67yCb8OwzUGvBp/uW4L8kWeuCAgVLASyQSE2RL/h3ml+W/sAGDBtA6zAVPnDhhomOVSCQS2ZJ/h4l5EkM64GbNm5EtuxTwEonEFMb+H+h5WicK/bqYAAAAAElFTkSuQmCC'),
                14,
                7,
                32,
                0,
                'PNG'
            );
            $this->setfont('helvetica', 'B', 10);
            $this->text(60, 8, 'ASISTENCIA TECNICA - LOCALIZACION DE FALLAS');
            $this->setfont('helvetica', '', 8);
            $this->text(178, 8, 'A2');

            $this->line(10, 19, 195, 19);
        }

        public function Footer()
        {
            $this->SetY(-15);
            $this->line(10, $this->getY(), 195, $this->getY());
            $this->SetFont('helvetica', 'I', 7);
            $this->text(
                178,
                $this->getY() + 4,
                'Pagina ' . $this->getAliasNumPage() . ' de ' . $this->getAliasNbPages()
            );
        }
    }
}

// create new PDF document
$pdf = new MYPDF('P', 'mm', 'A4', true, 'ISO-8859-1', false);
// set default monospaced font
$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

// set margins
$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
$pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

// set auto page breaks
$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

// set image scale factor
$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

$lv_first_page = true;

// Loop por cada evento
foreach ($vew_events as $lv_event_data) {
    // Agregar página (excepto la primera que ya se agrega automáticamente)
    if ($lv_first_page) {
        $pdf->AddPage('P');
        $lv_first_page = false;
    } else {
        $pdf->AddPage('P');
    }

    // Titulo
    $pdf->setfont('helvetica', 'B', 8);
    $pdf->SetY(22);
    $pdf->Cell(0, 6, 'INFORME TÉCNICO', 0, 1, 'C');
    // ENCABEZADO
  if(!($lv_event_data['steevtdte'] instanceof DateTime)) { $lv_event_data['steevtdte'] = new DateTime($lv_event_data['steevtdte']); }
    $lv_date = $lv_event_data['steevtdte']->format('d/m/Y');
    $pdf->text(15, 25, 'FECHA: ' . $lv_date);
    $pdf->text(140, 25, 'CONTACTO:');
    $lv_docatr = [];
  	$lv_docatr = $lv_event_data['evtdoc']['steevtdocatr'];
    $lv_numord = $vew_doc->getTagValue($vew_ste->cnssteatr, 'atr_pry');
    $lv_strtime = $lv_docatr['steevtdocstrtme'] ?? '';
    $lv_endtime = $lv_docatr['steevtdocendtme'] ?? '';

    // TABLA SUPERIOR
    $lv_buffertbl = '
  <table border="1" cellspacing="0" cellpadding="1" width="100%">
    <thead>
      <tr>
        <th width="110" align="center">N° ORDEN</th>
        <th width="140" align="center">Nro. de Medidor</th>
        <th width="60" align="center">Estado</th>
        <th width="60" align="center">Hora Arribo</th>
        <th width="60" align="center">Hora Partida</th>
        <th width="100" align="center">Valores de Tensión (Antes)</th>
        <th width="100" align="center">Valores de Tensión (Después)</th>
      </tr>
    </thead>
    <tbody>
  ';
    $lv_buffertbl .= '
      <tr style="height:30px">
        <td width="110">' . $lv_numord . '</td>
        <td width="140"></td>
        <td width="60"></td>
        <td width="60">' . $lv_strtime . '</td>
        <td width="60">' . $lv_endtime . '</td>
        <td width="100"></td>
        <td width="100"></td>
      </tr></tbody></table>
  ';
    $pdf->Ln(6);
    $pdf->writeHTML($lv_buffertbl);

    // BLOQUE FORMULARIO
    $y = $pdf->GetY() + 2;

    $pdf->setfont('helvetica', 'B', 8);
    $pdf->text(10, $y, 'Vincula entre:');
    $pdf->text(110, $y, 'Destino:');

    $pdf->setfont('helvetica', '', 8);
    $pdf->text(35, $y, $lv_docatr['steevtdocstrlnk'] ?? '');
    $pdf->text(130, $y, $lv_docatr['steevtdocendlnk'] ?? '');

    $pdf->line(35, $y + 7, 100, $y + 7);
    $pdf->line(130, $y + 7, 195, $y + 7);

    // DIRECCION FALLA
    $y += 10;

    $pdf->setfont('helvetica', 'B', 8);
    $pdf->text(10, $y, 'Dirección Falla:');

    $pdf->setfont('helvetica', '', 8);
    $pdf->text(40, $y, $lv_docatr['steevtdocadr']);

    $pdf->line(40, $y + 7, 195, $y + 7);

    // LOCALIDAD / PARTIDO
    $y += 10;

    $pdf->setfont('helvetica', 'B', 8);
    $pdf->text(10, $y, 'Localidad:');
    $pdf->text(110, $y, 'Partido:');

    $pdf->setfont('helvetica', '', 8);

    $pdf->text(35, $y, mb_convert_encoding($vew_ste->adr->lndtwntxt, 'UTF-8', 'iso-8859-1'));

    $pdf->line(35, $y + 7, 100, $y + 7);
    $pdf->line(135, $y + 7, 195, $y + 7);

    // ACTIVIDAD / MOTIVO - ZONA - SECTOR
    $y += 10;

    $pdf->setfont('helvetica', 'B', 8);
    $pdf->text(10, $y, 'Actividad / Motivo:');
    $pdf->text(120, $y, 'Zona:');
    $pdf->text(160, $y, 'Sector:');

    $pdf->setfont('helvetica', '', 8);
    $pdf->text(45, $y, $lv_docatr['cnstsktxt']);

    $pdf->line(45, $y + 7, 115, $y + 7);   // Actividad / Motivo
    $pdf->line(135, $y + 7, 155, $y + 7);   // Zona
    $pdf->line(175, $y + 7, 195, $y + 7);   // Sector

    // CROQUIS DE UBICACION
    $y += 12;

    $pdf->setfont('helvetica', 'B', 8);
    $pdf->text(10, $y, 'Croquis de ubicación:');
    $pdf->Image(
        '@' . base64_decode('iVBORw0KGgoAAAANSUhEUgAAAQMAAADCCAMAAAB6zFdcAAAAA3NCSVQICAjb4U/gAAAAJFBMVEX////8/PyUlJSzs7P29vbOzs7s7OylpaXj4+OOjo7c3NxhYWEnPjQBAAAFfUlEQVR4nO2di3LjKhBEGTE8/f//e2nJ2V0byJUcEVR2H4VUKk5JqGlGIFKMMQdwKrr+oJK1+lS8PXKyw4hZ2h84N/S6T6ga3Luo2Fh9+BkaqIrffjDWV59O1ECGXvgRhRPW+thcffgZPviDmGv1hd/0wRdX02DodTtcTQP6gD6gDwB9QB8A+oA+APQBfQDoA/oA0Af0AaAP6ANAH9AHgD6gDwB9QB8A+oA+APQBfQBO84F8/W/BHrwu1R+r+GBkHMabpdne6qycYwTV/RKI2Mp+RUO/FB29yqBDYy38SukLZ2lg4k58XBpXFW90qXvIeeTFNDXQ4r9zUBW7G1/+ujoB2sqmcYTSBVs1FzkvIBzwk7RaRHGKkRG6V0NVF4o7X2ZglX+LYkmJ1ob9Nn5i9g2cQImWRwL6e6KbCq8/ddtnVXTttYOb7evCrBU8PRIVBeAuKLvq+5FG82Y1l8/22PjxjRCMmMqYJ9pURiCmHgt8AGVUuuQQlugWDaEMi/sjWFnL7AoPQMvAy/t0iy74WwplDgB8v8yu8ADK4DPGFG/ZpmzFrcHBfFfeEDW2NH5wPjv8JOqM28p2+OxRcsSBb7MrPAJdy/0/tHWdHjyWh+Mt4wEhH82RkdB3E41zatM8d68yZ13Bq4RlJ8m271W8DHxQ9gYi3p82QjkyNXKufdXyQB1Hb+ZSRmlpb+s1+XMmNOHeCXexTG4a0C73MeUIUuf1cfd983GOdCuVermj9I4yxB4XD8pIrb2eJElnjFBaSz5qfGcd6CS03Gzr96Vjzllrq29XJI99O6mmo4FtrzsMpukDjXPWG0sXuY4Gw9dce31hyoSl2SSz1p3n/PvB1TSYMm+lBhfTIFMD+sBQA0ANGA8AfUANADVgPAD0ATUA1IDxANAH1ABQA8YDQB9QA0ANGA8AfUANADVgPAD0ATUA1IDxANAH1ABQA8YDQB9QA0ANGA8AfUANADVgPAD0ATUA1IDxANAH1ABQA8YDQB9QA0ANGA8AfUANADVgPAD0ATUA1IDxANAH1ABQA8YDQB9QA0ANpsUDNan6nZdotbvR4wl47fnATBBBWxqoidjicOA+mv19smZs8SyNJln3zRu5QX3RoL1/YtIZ6UQkxDonjerQ/RONWNfeRzOGszQ40IDi6ugnSIvikh+4j2Zu11HU794J9n/2ElUNe7MELa5EwHZ1Bu6nqp1er6fl4NAD4Ux6G80PzUPQC7hbrpAf8Lf6R7ZG7jfJD6vzXU2R7qF/1R8cD3qafTnnvlLVtKqzW8aXaPugVxlCyIs8p6G755vRjN2LkaZnUr1+k+fdzBExPfYLTvd8VbMq9ovI07MxppRdCt4mTcn1HkvvRWnqhz16sWtxDEjN429LGDknvhDyMAoT53xe4q34wAef5d+UNOa5yHnD1UuhNpQJmfNlLmiX4gInDkW25ERraiJ/T01Uis9v6ZMted82DlWtWl8ey1vmJ8Kdrw+He/pCpOnQv+XbUff7sN71es9bYjrMWraMVM1iRg/buxlz75e/gBN16znjDu2ZDXkWt6Z6cUZ6HgPnzSv6zYz9Is8l1DHYcYfNnUHK+hJv+UFqnn9PtjMdsluz3dZVUbe8nmd6B8hO1Bbf1OnnXwLTo13Z3rMLzVRUX2lzhn0TH9rv1uV21gLXFvuf0hLWR/kzLGrU71Q1DH6L5NW2E0U6e1Jcu2dn3ROaJLRy3mc7eE5RntP16pZZDXhWqrKdYz0YwbeaPI5OEVQkbi44ypwETakREwdnJjJXW3xfpmjQ8cGkxDxzNKAP6ANAH9AHgD6gDwB9QB8A+oA+APQBfQDoA/oA0Af0AaAP6ANAH9AHgD6gDwB9QB8A+oA+APQBfQDog3E++A+qXzzNXt/PqQAAAABJRU5ErkJggg=='),
        20,
        $pdf->GetY() + 6,
        150,
        30,
        'PNG'
    );
    $y += 6;

    // CODIGOS DE BAREMO
    $y += 35;
    $pdf->SetY($y);
    $pdf->setfont('helvetica', 'B', 9);
    $pdf->Cell(0, 6, 'CODIGOS DE BAREMO', 0, 1, 'C');

    $pdf->setfont('helvetica', '', 7);

    $lv_buffer = '
  <table border="1" cellpadding="2" cellspacing="0" width="100%">
    <tr>
      <th width="270">Código</th>
      <th width="70">Cant</th>

      <th width="270">Código</th>
      <th width="70">Cant</th>
    </tr>';
    $lv_cnt = count($vew_tsk);

    for ($i = 0; $i < $lv_cnt; $i += 2) {

        // IZQUIERDA 
        $lv_txtlft = '';
        $lv_qtylft = '';

        if (isset($vew_tsk[$i])) {
            $lv_rowl = $vew_tsk[$i];
            if (!empty($lv_rowl['cnstskcodext'])) {
                $lv_txtlft .= '<b>' . $lv_rowl['cnstskcodext'] . '</b> ';
            }

          	$lv_rowl['cnstsktxt'] = mb_convert_encoding($lv_rowl['cnstsktxt'], 'UTF-8', 'iso-8859-1');
            $lv_txtlft .= $lv_rowl['cnstsktxt'];
            if (strtoupper($lv_rowl['cnstsktxt']) == strtoupper($lv_docatr['cnstsktxt'] ?? '') || $lv_rowl['cnstskcodext'] == ($lv_docatr['cnstskcodext'] ?? '')) {
              $lv_qtylft = $lv_docatr['steevtdocqty'];
            }
        }

        // DERECHA
        $lv_txtrgh = '';
        $lv_qtyrgh = '';

        if (isset($vew_tsk[$i + 1])) {
            $lv_rowr = $vew_tsk[$i + 1];

            if (!empty($lv_rowr['cnstskcodext'])) {
                $lv_txtrgh .= '<b>' . $lv_rowr['cnstskcodext'] . '</b> ';
            }
					
          	$lv_rowr['cnstsktxt'] = mb_convert_encoding($lv_rowr['cnstsktxt'], 'UTF-8', 'iso-8859-1');
            $lv_txtrgh .= $lv_rowr['cnstsktxt'];
            if (strtoupper($lv_rowr['cnstsktxt']) == strtoupper($lv_docatr['cnstsktxt'] ?? '') || $lv_rowr['cnstskcodext'] == ($lv_docatr['cnstskcodext'] ?? '')) {
                $lv_qtyrgh = $lv_docatr['steevtdocqty'];
            }
        }
        // FILA
        $lv_buffer .= '
      <tr>
        <td>' . $lv_txtlft . '</td>
        <td align="center">' . $lv_qtylft . '</td>
        <td>' . $lv_txtrgh . '</td>
        <td align="center">' . $lv_qtyrgh . '</td>
      </tr>
    ';
    }
    $lv_buffer .= '</table>';
    $pdf->writeHTML($lv_buffer);

    // MATERIALES
    $pdf->setfont('helvetica', 'B', 9);
    $pdf->Cell(0, 6, 'MATERIALES', 0, 1, 'C');

    $pdf->setfont('helvetica', '', 7);

    $lv_buffer = '
    <table border="1" cellpadding="2" cellspacing="0" width="100%">
      <tr>
        <th width="70">Matrícula</th>
        <th width="200">Descripción</th>
        <th width="60">Cant</th>

        <th width="70">Matrícula</th>
        <th width="210">Descripción</th>
        <th width="60">Cant</th>
      </tr>';

    // filas 
    for ($i = 0; $i < 5; $i++) {
        $lv_buffer .= '
      <tr>
        <td></td><td></td><td></td>
        <td></td><td></td><td></td>
      </tr>';
    }

    $lv_buffer .= '</table>';

    $pdf->writeHTML($lv_buffer);

    // TRABAJOS PROGRAMABLES / OBSERVACIONES
    $y = $pdf->GetY();

    $pdf->setfont('helvetica', 'B', 8);
    $pdf->text(10, $y, 'Trabajos Programables / Observaciones:');

    $pdf->line(10, $y + 5, 195, $y + 5);

    $y += 10;

    $pdf->setfont('helvetica', '', 8);
    $lv_obs = $lv_docatr['steevtdocobs'] ?? '';
    $pdf->text(10, $y, $lv_obs);

    $pdf->line(10, $y + 5, 195, $y + 5);

    // DATOS DE CIERRE

    $lv_grprow = null;

    foreach ($vew_budtsk as $row) {
        if (($row['cnstskclscodext'] ?? '') === 'CUADRILLA') {
            $lv_grprow = $row;
            break;
        }
    }
    $lv_emp = [];

    if ($lv_grprow) {
        $lv_prefix = ($lv_grprow['budmatrow'] ?? '') . '.';

        foreach ($vew_budtsk as $row) {
            $lv_row = $row['budmatrow'] ?? '';
            if ($lv_row !== '' && strpos($lv_row, $lv_prefix) === 0) {
                if (($row['srcobjtyp'] ?? '') === 'HHR_EMP') {
                    $lv_txt = trim($row['srcobjtxt'] ?? '');
                    if ($lv_txt !== '') {
                        $lv_emp[] = $lv_txt;
                    }
                }
            }
        }
    }

    $lv_mov = '';
    foreach ($vew_budtsk as $row) {
        if (($row['srcobjtyp'] ?? '') === 'LOG_VHC') {
            $lv_mov = trim($row['srcobjcodext'] ?? '');
            break;
        }
    }
    $y += 7;
    $pdf->setfont('helvetica', 'B', 8);
    $pdf->text(10, $y, 'Móvil N°:');
    $pdf->text(40, $y, 'Integrantes:');
    $pdf->text(120, $y, 'Firma Cliente:');

    $pdf->setfont('helvetica', '', 8);
    $pdf->text(25, $y, $lv_mov);
    $pdf->text(70, $y, mb_convert_encoding($vew_ste->rspobjtxt, 'UTF-8', 'iso-8859-1'));

    $pdf->line(70, $y + 5, 110, $y + 5);
    $pdf->line(120, $y + 5, 195, $y + 5);
    // ayudante 1
    $y += 5;
    $pdf->text(70, $y, mb_convert_encoding($lv_emp[0] ?? '', 'UTF-8', 'iso-8859-1'));
    $pdf->line(70, $y + 5, 110, $y + 5);

    // ayudante 2
    $y += 5;
    $pdf->text(70, $y, mb_convert_encoding($lv_emp[1] ?? '', 'UTF-8', 'iso-8859-1'));
    $pdf->line(70, $y + 5, 110, $y + 5);
    $y += 5;
    // firmas
    $pdf->setfont('helvetica', 'B', 8);
    $pdf->text(10, $y, 'Firma:');
    $pdf->text(110, $y, 'Controló:');

    $pdf->line(25, $y + 5, 90, $y + 5);
    $pdf->line(135, $y + 5, 195, $y + 5);

    // PIE FINAL 
    $y = $pdf->GetY() + 5;

    $pdf->setfont('helvetica', 'B', 7);
    $pdf->text(10, $y, 'NT 7 - Asistencia Técnica');

    $y += 3;

    // Recuadros
    $pdf->Rect(10, $y, 60, 12);
    $pdf->Rect(75, $y, 60, 12);
    $pdf->Rect(140, $y, 55, 12);

    $pdf->setfont('helvetica', '', 6);

    // Bloque izquierdo
    $pdf->text(12, $y + 4, 'Fecha de Edición:');
    $pdf->text(12, $y + 8, 'Elaboró:');

    $pdf->text(45, $y + 4, '03/10/2013');
    $pdf->text(45, $y + 8, 'Jose Roma');

    // Bloque central
    $pdf->text(77, $y + 4, 'Fecha Actualización:');
    $pdf->text(77, $y + 8, 'Supervisó:');

    $pdf->text(115, $y + 8, 'Anibal Aroldo');

    // Bloque derecho
    $pdf->text(142, $y + 4, 'Revisión:');
    $pdf->text(142, $y + 8, 'Aprobó:');

    $pdf->text(165, $y + 4, 'N°0');
    $pdf->text(165, $y + 8, 'Daniel Moreno');

} // Fin del loop foreach de eventos

// ---------------------------------------------------------
$pdf->Output('ASISTENCIA_TECNICA_LOCALIZACION_FALLAS.pdf');
?>