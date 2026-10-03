public class ParkLocator {

    public static String[] country(String theCountry) {

        ParkService.ParksImplPort parkSvc =
            new ParkService.ParksImplPort();

        return parkSvc.byCountry(theCountry);
    }
}