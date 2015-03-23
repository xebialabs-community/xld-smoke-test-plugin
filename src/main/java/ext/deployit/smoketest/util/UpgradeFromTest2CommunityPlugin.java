/**
 * THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
 * FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.
 */
package ext.deployit.smoketest.util;


import com.xebialabs.deployit.server.api.repository.RawRepository;
import com.xebialabs.deployit.server.api.upgrade.Upgrade;
import com.xebialabs.deployit.server.api.upgrade.UpgradeException;
import com.xebialabs.deployit.server.api.upgrade.Version;


public class UpgradeFromTest2CommunityPlugin extends Upgrade {
    @Override
    public boolean doUpgrade(final RawRepository repository) throws UpgradeException {

        repository.renameType("tests2.TestRunner", "smoketest.Runner");
        repository.renameType("tests2.HttpRequestTest", "smoketest.HttpRequestTest");
        repository.renameType("tests2.HttpRequestTest", "smoketest.HttpRequestTest");
        repository.renameType("tests2.ExecutedHttpRequestTest", "smoketest.ExecutedHttpRequestTest");
        repository.renameType("tests2.ExecutedHttpPostRequestTest", "smoketest.ExecutedHttpPostRequestTest");
        repository.renameType("tests2.ExecutedHttpPostFileRequestTest", "smoketest.ExecutedHttpPostRequestFileTest");

        return true;
    }

    @Override
    public Version upgradeVersion() {
        return Version.valueOf("deployit", "4.5.0");
    }
}
